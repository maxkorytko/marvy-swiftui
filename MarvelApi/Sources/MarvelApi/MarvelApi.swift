public struct MarvelApi {
    public init() {
    }

    public func fetchCharacters() async -> CharacterDataWrapper {
        .init(data: .init(results: []))
    }
}
