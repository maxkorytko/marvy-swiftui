import MarvelApi
import MarvelSwiftUI
import SwiftUI

struct CharacterView: View {
    let character: Character

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top) {
                if let thumbnail = character.thumbnail {
                    RemoteImage(image: thumbnail)
                        .frame(width: geometry.size.width / 3, height: geometry.size.width / 2)
                }

                VStack(alignment: .leading, spacing: 14) {
                    if let name = character.name {
                        Text(name)
                            .font(.headline)
                    }

                    if let description = character.description {
                        Text(description)
                            .font(.body)
                    }
                    Spacer()
                }
            }
            .padding()
        }
        .frame(height: 200)
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView(character: .milesMorales)
            .frame(height: 200)
    }
}
