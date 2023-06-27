import SwiftUI

struct LoadableView<T, Content: View>: View {
    private let loadable: Loadable<T>?

    @ViewBuilder private let content: (T) -> Content

    init(_ loadable: Loadable<T>?, @ViewBuilder content: @escaping (T) -> Content) {
        self.loadable = loadable
        self.content = content
    }

    var body: some View {
        VStack {
            if loadable == nil {
                EmptyView()
            }

            if case .loading = loadable {
                ProgressView()
            }

            if case let .loaded(result) = loadable {
                switch result {
                case .failure:
                    Text("Error")
                case .success(let model):
                    self.content(model)
                }
            }
        }
    }
}

struct LoadableView_Previews: PreviewProvider {
    static var previews: some View {
        LoadableView(.loading) {
            EmptyView()
        }
    }
}
