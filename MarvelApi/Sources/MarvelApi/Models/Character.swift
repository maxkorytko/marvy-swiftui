import Foundation

public typealias Characters = DataWrapper<Character>

public struct Character: ApiResource {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case thumbnail
    }

    public let id: Int?
    public let name: String?
    public let description: String?
    public let thumbnail: Image?
    public let uuid: UUID = .init()
}

extension Character {
    public init(
        name: String?,
        description: String?,
        thumbnail: Image
    ) {
        self.id = nil
        self.description = description
        self.name = name
        self.thumbnail = thumbnail
    }
}
