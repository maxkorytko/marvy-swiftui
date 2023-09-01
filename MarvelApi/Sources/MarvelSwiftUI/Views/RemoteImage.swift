import MarvelApi
import SwiftUI

public struct RemoteImage: View {
    public let image: MarvelApi.Image

    public init(image: MarvelApi.Image) {
        self.image = image
    }

    public var body: some View {
        GeometryReader { proxy in
            AsyncImage(url: image.url(size: proxy.size)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(image: .init(path: "https://i.annihil.us/u/prod/marvel/i/mg/3/40/4bb4680432f73"))
    }
}
