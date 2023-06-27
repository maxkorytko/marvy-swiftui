import Foundation

public typealias Characters = DataWrapper<Character>

public struct Character: ApiResource {
    public let id: Int?
    public let name: String?
}
