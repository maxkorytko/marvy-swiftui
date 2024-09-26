import Dependencies
import Foundation
import MarvelApi

final class Api: DependencyKey {
    static public var liveValue: Api = .init(client: MarvelApiClient())
    static public var previewValue: Api = .init(client: MarvelApiClientStub())

    let client: MarvelApiClientType

    init(client: MarvelApiClientType) {
        self.client = client
    }
}

private struct MarvelApiClientStub: MarvelApiClientType {
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
