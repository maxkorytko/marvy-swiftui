import MarvelApi
import Foundation

extension Character {
    static let milesMorales: Self = .init(
        name: "Spider-Man (Miles Morales)",
        description: "Bitten by a spider when he was a teenager.",
        thumbnail: .init(path: "https://i.annihil.us/u/prod/marvel/i/mg/f/50/537bcfa1eed73")
    )

    static let ironMan: Self = .init(
        name: "Iron Man",
        description: "Tony Stark made the first Iron Man when he was a prisoner.",
        thumbnail: .init(path: "https://i.annihil.us/u/prod/marvel/i/mg/9/c0/527bb7b37ff55")
    )
}
