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

extension String {

    func loadSwiftFiles() -> [URL] {
        guard let rootURL = URL(string: self) else {
            return []
        }
        return loadFiles(url: rootURL).filter {
            $0.absoluteString.hasSuffix(".swift")
        }
    }

    func loadFiles(isRecursion: Bool) -> [URL] {
        guard let rootURL = URL(string: self) else {
            return []
        }
        return loadFiles(url: rootURL, isRecursion: isRecursion)
    }

    private func loadFiles(url: URL, isRecursion: Bool = true) -> [URL] {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            return fileURLs.filter {
                !$0.absoluteString.hasSuffix(".git/") && !$0.absoluteString.hasSuffix("Pods/")
            }.map {
                $0.absoluteString.last == "/" && isRecursion ? loadFiles(url: $0) : [$0]
            }.reduce([], +)
        } catch {
            print("Error while enumerating files \(url.path): \(error.localizedDescription)")
        }
        return []
    }

}
