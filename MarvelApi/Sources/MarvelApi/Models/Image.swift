import Foundation

public struct Image: ApiResource {
    public let path: String?
    public let `extension`: String?

    public enum CodingKeys: CodingKey {
        case path
        case `extension`
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.path = try container.decodeIfPresent(String.self, forKey: .path)?.replacingOccurrences(of: "http://", with: "https://")
        self.`extension` = try container.decodeIfPresent(String.self, forKey: .extension)
    }

    public init(path: String, extension: String = "jpg") {
        self.path = path
        self.`extension` = `extension`
    }
}

extension Image {
    public enum Variant: String, CaseIterable {
        case portraitSmall = "portrait_small"
        case portraitMedium = "portrait_medium"
        case portraitXLarge = "portrait_xlarge"
        case landscapeSmall = "landscape_small"
        case landscapeLarge = "landscape_large"

        var size: CGSize {
            switch self {
            case .portraitSmall:
                return CGSize(width: 50, height: 75)
            case .portraitMedium:
                return CGSize(width: 100, height: 150)
            case .portraitXLarge:
                return CGSize(width: 150, height: 225)
            case .landscapeSmall:
                return CGSize(width: 120, height: 90)
            case .landscapeLarge:
                return CGSize(width: 190, height: 140)
            }
        }

        private static let landscapeVariants: [Variant] = Variant.allCases
            .filter { $0.size.isLandscape }
            .sorted()

        private static let portraitVariants: [Variant] = Variant.allCases
            .filter { !$0.size.isLandscape }
            .sorted()


        static func matching(size: CGSize) -> Self? {
            let variants: [Variant] = size.isLandscape ? landscapeVariants : portraitVariants
            return variants.filter { $0.size.width >= size.width && $0.size.height >= size.height }.first ?? variants.last
        }
    }

    public func url(size: CGSize) -> URL? {
        Variant.matching(size: size).flatMap { url(variant: $0) }
    }

    public func url(variant: Variant) -> URL? {
        guard let path, let `extension` else {
            return nil
        }

        let urlString = ((path as NSString)
            .appendingPathComponent(variant.rawValue) as NSString)
            .appendingPathExtension(`extension`)


        return urlString.flatMap { URL(string: $0) }
    }
}

private extension CGSize {
    var aspectRatio: CGFloat {
        height > 0 ? width / height : 0
    }

    var isLandscape: Bool {
        aspectRatio > 1
    }
}

private extension Array where Self.Element == Image.Variant {
    func sorted() -> Self {
        sorted { $0.size.width < $1.size.width }
    }
}
