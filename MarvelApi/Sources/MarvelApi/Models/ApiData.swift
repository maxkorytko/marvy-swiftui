import Foundation

public struct DataWrapper<T: Decodable>: Decodable {
    public let data: DataContainer<T>?
}

public struct DataContainer<T: Decodable>: Decodable {
    public let results: [T]?
}
