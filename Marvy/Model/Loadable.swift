import Foundation

enum Loadable<T> {
    case loading
    case loaded(T)
}

extension Loadable: Equatable where T: Equatable { }
