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

        func update(characters: [LoadableCharacter]?) -> Self {
            Self(characters: characters)
        }
    }

    @ObservationIgnored @Dependency(Api.self) private var api
    
    private(set) var state: State = .init(
        characters: nil
    )

    func fetchCharacters() async {
        if state.characters == nil {
            state = state.update(characters: (1..<10).map { _ in .loading(id: UUID()) })
        }

        do {
            let characters = try await api.client.fetchCharacters(
                pagination: .init(page: 1, pageSize: 20)
            )
            self.state = state.update(
                characters: characters.data?.results?.map { character in
                    .character(character)
                }
            )
        } catch {
            self.state = state.update(characters: [])
        }
    }
}

@MainActor
struct CharactersView: View {
    private let viewModel: CharactersViewModel = .init()

    var body: some View {
        ZStack {
            if let characters = viewModel.state.characters {
                List(characters) { character in
                    CharacterRow(character: character)
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
