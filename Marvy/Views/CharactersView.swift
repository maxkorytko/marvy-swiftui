import ComposableArchitecture
import MarvelApi
import SwiftUI

struct CharactersFeature: Reducer {
    struct State: Equatable {
        var characters: Loadable<Characters>?
    }

    enum Action {
        case fetchCharacters
        case charactersResponse(TaskResult<Characters>)
    }

    @Dependency(\.apiClient) private var apiClient

    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .fetchCharacters:
            state.characters = .loading
            return fetchCharacters()
        case let .charactersResponse(response):
            state.characters = .loaded(response)
            return .none
        }
    }

    private func fetchCharacters() -> ComposableArchitecture.Effect<Action> {
        return .run { send in
            do {
                let characters = try await apiClient.fetchCharacters()
                await send(.charactersResponse(.success(characters)))
            } catch {
                await send(.charactersResponse(.failure(error)))
            }
        }
    }
}

struct CharactersView: View {
    let store: StoreOf<CharactersFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                LoadableView(viewStore.characters) {
                    CharactersList(characters: $0.data?.results ?? [])
                }
            }
            .task {
                await viewStore.send(.fetchCharacters).finish()
            }
        }
    }
}

extension CharactersView {
    init() {
        self.init(store: Store(initialState: .init(), reducer: {
            CharactersFeature()
        }))
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView()
    }
}
