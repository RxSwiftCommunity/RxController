import Foundation

extension String {

    func match(with pattern: String) -> [String] {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        guard let results = regex?.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)), !results.isEmpty else {
            return []
        }
        return results.map {
            (self as NSString).substring(with: $0.range)
        }
    }

    func matchFirst(with pattern: String) -> String? {
        return match(with: pattern).first
    }

    func last(separatedBy string: String) -> String? {
        return self.components(separatedBy: string).last
    }

    func first(separatedBy string: String) -> String? {
        return self.components(separatedBy: string).first
    }

}
