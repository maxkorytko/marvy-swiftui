import Foundation

public typealias Characters = DataWrapper<Character>

public struct Character: ApiResource {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case thumbnail
    }

    public let id: Int?
    public let name: String?
    public let thumbnail: Image?
    public let uuid: UUID = .init()
}
