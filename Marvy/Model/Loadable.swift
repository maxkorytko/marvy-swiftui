import ComposableArchitecture
import Foundation

enum Loadable<T> {
    case loading
    case loaded(TaskResult<T>)
}

extension Loadable: Equatable where T: Equatable { }
