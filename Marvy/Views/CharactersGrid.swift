import MarvelApi
import MarvelSwiftUI
import SwiftUI

struct CharactersGrid: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?

    let characters: [Character]

    init(characters: [Character]) {
        self.characters = characters.filter {
            $0.thumbnail?.path?.contains("image_not_available") == false
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                let gridLayout = GridLayout(geometry: geometry, verticalSizeClass: verticalSizeClass)

                LazyVGrid(columns: gridLayout.columns, spacing: 0) {
                    ForEach(characters, id: \.uuid) { character in
                        if let thumbnail = character.thumbnail {
                            RemoteImage(image: thumbnail)
                                .frame(width: gridLayout.itemWidth, height: gridLayout.itemHeight)
                        }
                    }
                }
            }
        }
    }
}

private struct GridLayout {
    let columns: [GridItem]
    let itemWidth: CGFloat
    let itemHeight: CGFloat

    init(geometry: GeometryProxy, verticalSizeClass: UserInterfaceSizeClass?) {
        let itemsPerRow = verticalSizeClass == .compact ? 5 : 3

        self.itemWidth = geometry.size.width / CGFloat(itemsPerRow)
        self.itemHeight = self.itemWidth / MarvelApi.Image.Variant.portraitMedium.aspectRatio

        var columns: [GridItem] = []
        for _ in 1...itemsPerRow {
            columns.append(GridItem(.fixed(itemWidth), spacing: 0))
        }
        self.columns = columns
    }
}

struct CharactersGrid_Previews: PreviewProvider {
    static var previews: some View {
        CharactersGrid(characters: [
            .ironMan,
            .milesMorales
        ])
    }
}
