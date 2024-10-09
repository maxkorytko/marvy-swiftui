import Foundation

extension Endpoint {
    static let characters: Endpoint = "characters"

    func paginate(_ pagination: Pagination?) -> Self {
        guard let pagination else {
            return self
        }

        return append(queryParams: [
            "limit": String(describing: pagination.pageSize),
            "offset": String(describing: pagination.pageSize * max(0, pagination.page - 1))
        ])
    }
}

extension MarvelApiClient: MarvelApiClientType {
    public func fetchCharacters(pagination: Pagination?) async throws -> Characters {
        try await makeApiRequest(endpoint: .characters.paginate(pagination))
    }
}
