import Foundation

enum Loadable<T> {
    case loading
    case success(T)
    case error(Error)
}
