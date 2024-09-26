import Dependencies
import MarvelApi
import SwiftUI

final class CharactersViewModel {
    @Dependency(Api.self) var api
}

struct CharactersView: View {
    private let viewModel: CharactersViewModel = .init()

    var body: some View {
        Text("Character")
            .task {
                do {
                    _ = try await viewModel.api.client.fetchCharacters()
                } catch {
                    print(error)
                }
            }
    }
}

// MARK: - Previews

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView()
    }
}
