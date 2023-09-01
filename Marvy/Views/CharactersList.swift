import MarvelApi
import SwiftUI

struct CharactersList: View {
    private let characters: [Character]

    init(characters: [Character]) {
        self.characters = characters
    }

    var body: some View {
        if characters.isEmpty == false {
            List(characters, id:\.uuid) { character in
                CharacterView(character: character)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }

        if characters.isEmpty {
            Text("Empty")
        }
    }
}

// MARK: - Previews

struct CharactersList_Previews: PreviewProvider {
    static var previews: some View {
        CharactersList(characters: [.milesMorales, .ironMan])
    }
}
