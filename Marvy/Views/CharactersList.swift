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
            .foregroundColor(.white)
        }

        if characters.isEmpty {
            Text("Empty")
        }
    }
}

struct CharacterView: View {
    let character: Character

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.black.opacity(0.5))

            HStack {
                if let thumbnail = character.thumbnail {
                    Thumbnail(image: thumbnail)
                        .frame(width: 100, height: 150)
                }

                if let name = character.name {
                    Text(name)
                }
            }
            .frame(height: 100)
            .padding()
        }
    }
}

struct Thumbnail: View {
    let image: MarvelApi.Image

    var body: some View {
        GeometryReader { proxy in
            AsyncImage(url: image.url(size: proxy.size))
        }
    }
}

// MARK: - Previews

struct CharactersList_Previews: PreviewProvider {
    static var previews: some View {
        CharactersList(characters: [
            Character(name: "Spider-Man", thumbnail: .init(path: "spider-man"))
        ])
    }
}
