import Foundation

public protocol ApiResource: Equatable, Decodable { }

public struct DataWrapper<T: ApiResource>: ApiResource {
    public let data: DataContainer<T>?
}

public struct DataContainer<T: ApiResource>: ApiResource {
    public let results: [T]?
}
