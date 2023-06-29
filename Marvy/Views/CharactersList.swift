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
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
        }

        if characters.isEmpty {
            Text("Empty")
        }
    }
}

struct CharacterView: View {
    let character: Character

    var body: some View {
        HStack {
            if let thumbnail = character.thumbnail {
                Thumbnail(image: thumbnail)
            }

            if let name = character.name {
                Text(name)
            }
        }
    }
}

struct Thumbnail: View {
    let image: MarvelApi.Image

    var body: some View {
        Rectangle()
            .frame(width: 50, height: 50)
            .background(Color.red)
    }
}
