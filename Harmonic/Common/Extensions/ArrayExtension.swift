import Foundation

extension Array where Element: Hashable {
    func uniqued() -> Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}

extension Array where Element == APIImage {
    func getImageUrl(for resolution: APIImage.Resolution) -> String? {
        switch resolution {
        case .high: return self.first(where: { $0.width ?? 0 >= 640 && $0.height ?? 0 >= 640 })?.url ?? self.first?.url
        case .medium: return self.first(where: { $0.width ?? 0 > 80 && $0.height ?? 0 > 80 })?.url ?? self.first?.url
        case .low: return self.first(where: { $0.width ?? 0 <= 80 && $0.height ?? 0 <= 80 })?.url ?? self.first?.url
        }
    }
}
