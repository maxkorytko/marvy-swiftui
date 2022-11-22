import CryptoKit
import Foundation

public struct MarvelApi {
    public struct Credentials {
        public let publicKey: String
        public let privateKey: String
    }

    enum Error: Swift.Error {
        case invalidRequest
    }

    private let credentials: Credentials

    private let urlSession: URLSession

    private let jsonDecoder = JSONDecoder()

    public init() {
        guard
            let publicKey = ProcessInfo.processInfo.environment["MARVEL_API_PUBLIC_KEY"],
            let privateKey = ProcessInfo.processInfo.environment["MARVEL_API_PRIVATE_KEY"] else {
            fatalError("No API Credentials")
        }

        self.init(credentials: .init(publicKey: publicKey, privateKey: privateKey))
    }

    public init(credentials: Credentials) {
        self.credentials = credentials
        self.urlSession = URLSession(configuration: .default)
    }

    public func fetchCharacters() async throws -> CharacterDataWrapper {
        try await makeApiRequest(endpoint: "characters")
    }

    private func makeApiRequest<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let (data, _) = try await urlSession.data(for: ApiRequest(credentials: credentials, endpoint: endpoint))

        return try jsonDecoder.decode(T.self, from: data)
    }
}

struct Endpoint: ExpressibleByStringLiteral {
    let path: String

    init(stringLiteral value: StringLiteralType) {
        self.path = value
    }
}

struct ApiRequest {
    let credentials: MarvelApi.Credentials

    let endpoint: Endpoint

    let urlRequest: URLRequest?

    init(credentials: MarvelApi.Credentials, endpoint: Endpoint) {
        self.credentials = credentials
        self.endpoint = endpoint

        let nonce = String(format: "%.0f", Date().timeIntervalSince1970)

        let hash = "\(nonce)\(credentials.privateKey)\(credentials.publicKey)".data(using: .utf8).map { data in
            Insecure.MD5.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()
        }

        self.urlRequest = hash
            .flatMap { hash in
                var components = URLComponents()

                components.scheme = "https"
                components.host = "gateway.marvel.com"
                components.path = "/v1/public/\(endpoint.path)"

                components.queryItems = [
                    .init(name: "ts", value: "\(nonce)"),
                    .init(name: "apikey", value: credentials.publicKey),
                    .init(name: "hash", value: hash)
                ]

                return components.url
            }
            .map { url in
                URLRequest(url: url)
            }
    }
}

extension URLSession {
    func data(for apiRequest: ApiRequest) async throws -> (Data, URLResponse) {
        guard let urlRequest = apiRequest.urlRequest else {
            throw MarvelApi.Error.invalidRequest
        }

        return try await data(for: urlRequest)
    }
}
