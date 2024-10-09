import Foundation

public struct Pagination {
    public let page: Int
    public let pageSize: Int

    public init(page: Int, pageSize: Int) {
        self.page = page
        self.pageSize = pageSize
    }
}
