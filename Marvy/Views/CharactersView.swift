import Dependencies
import MarvelApi
import MarvelSwiftUI
import SwiftUI

enum LoadableCharacter: Identifiable {
    case loading(id: UUID)
    case character(Character)

    var id: UUID {
        switch self {
        case let .loading(id):
            id
        case let .character(character):
            character.uuid
        }
    }
}

@Observable @MainActor final class CharactersViewModel {
    struct State {
        let characters: [LoadableCharacter]?
        let currentPage: Int
        let isLoading: Bool

        func update(
            characters: [LoadableCharacter]?,
            currentPage: Int,
            isLoading: Bool
        ) -> Self {
            Self(
                characters: characters,
                currentPage: currentPage,
                isLoading: isLoading
            )
        }
    }

    @ObservationIgnored @Dependency(Api.self) private var api
    
    private(set) var state: State = .init(
        characters: nil,
        currentPage: 0,
        isLoading: false
    )

    func fetchCharacters() async {
        guard !state.isLoading else { return }

        if state.characters == nil {
            state = state.update(
                characters: (1..<10).map { _ in .loading(id: UUID()) },
                currentPage: state.currentPage,
                isLoading: true
            )
        } else {
            state = state.update(
                characters: state.characters,
                currentPage: state.currentPage,
                isLoading: true
            )
        }

        do {
            let characters = try await api.client.fetchCharacters(
                pagination: .init(page: state.currentPage, pageSize: 20)
            )
            self.state = state.update(
                characters: {
                    let fetchedCharacters = characters.data?.results?.map { character in
                        LoadableCharacter.character(character)
                    } ?? []

                    return if let characters = state.characters, state.currentPage > 0 {
                        characters + fetchedCharacters
                    } else {
                        fetchedCharacters
                    }
                }(),
                currentPage: state.currentPage + 1,
                isLoading: false
            )
        } catch {
            self.state = state.update(
                characters: state.characters == nil ? [] : state.characters,
                currentPage: state.currentPage,
                isLoading: false
            )
        }
    }
}

@MainActor
struct CharactersView: View {
    private let viewModel: CharactersViewModel = .init()

    var body: some View {
        ZStack {
            if let characters = viewModel.state.characters {
                List {
                    ForEach(characters) { character in
                        CharacterRow(character: character)
                    }
                    
                    if viewModel.state.currentPage > 0 {
                        Text("Loading")
                            .task {
                                await viewModel.fetchCharacters()
                            }
                    }
                }
            }
        }
        .task {
            await viewModel.fetchCharacters()
        }
    }
}

struct CharacterRow: View {
    let character: LoadableCharacter

    var body: some View {
        switch character {
        case .loading:
            CharacterLoadingView()
        case let .character(character):
            render(character)
        }
    }

    private func render(_ character: Character) -> some View {
        HStack {
            if let image = character.thumbnail {
                RemoteImage(image: image)
                    .frame(width: 100, height: 100)
            }

            if let name = character.name {
                Text(name)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

struct CharacterLoadingView: View {
    var body: some View {
        HStack {
            Text("Loading")
        }
    }
}

// MARK: - Previews

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView()
    }
}
