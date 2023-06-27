import Dependencies
import MarvelApi
import Foundation

protocol ApiClient {
    func fetchCharacters() async throws -> Characters
}

extension MarvelApi: ApiClient { }

struct ApiClientStub: ApiClient {
    private static let jsonDecoder: JSONDecoder = .init()

    private func parseJsonFile<T: Decodable>(name: String) throws -> T {
        guard let jsonFile = Bundle.main.url(forResource: name, withExtension: "json") else {
            fatalError("File \(name).json not found!")
        }

        guard let data = try String(contentsOf: jsonFile, encoding: .utf8).data(using: .utf8) else {
            fatalError("Unable to decode JSON in file \(name).json")
        }

        return try Self.jsonDecoder.decode(T.self, from: data)
    }

    func fetchCharacters() async throws -> Characters {
        try parseJsonFile(name: "characters")
    }
}

// MARK: - Dependency Injection

private enum ApiClientDependencyKey: DependencyKey {
    static let liveValue: ApiClient = MarvelApi()
    static let previewValue: ApiClient = ApiClientStub()
}

extension DependencyValues {
  var apiClient: ApiClient {
    get { self[ApiClientDependencyKey.self] }
    set { self[ApiClientDependencyKey.self] = newValue }
  }
}
