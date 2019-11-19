import Commander
import Foundation

func loadSwiftFiles(root: String) -> [URL] {
    guard let rootURL = URL(string: root) else {
        return []
    }
    return loadFiles(url: rootURL).filter { $0.absoluteString.hasSuffix(".swift") }
}

func loadFiles(url: URL) -> [URL] {
    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        return fileURLs.filter {
            !$0.absoluteString.hasSuffix(".git/") && !$0.absoluteString.hasSuffix("Pods/")
        }.map {
            $0.absoluteString.last == "/" ? loadFiles(url: $0) : [$0]
        }.reduce([], +)
    } catch {
        print("Error while enumerating files \(url.path): \(error.localizedDescription)")
    }
    return []
}

let main = command {
    loadSwiftFiles(root: "/Users/meng/Documents/Xcode/tipstar-ios/").forEach {
        print($0.absoluteString)
    }
}

main.run()