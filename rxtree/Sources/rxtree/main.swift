import Commander
import Foundation

struct Pattern {
    static let iegalIdentifier = "[a-zA-Z\\_][0-9a-zA-Z\\_]*"
}

func loadSwiftFiles(root: String) -> [URL] {
    guard let rootURL = URL(string: root) else {
        return []
    }
    return loadFiles(url: rootURL).filter {
        $0.absoluteString.hasSuffix(".swift")
    }
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

func filterViewControllers(from urls: [URL]) -> [Keyword] {
    return urls.map { url in
        url.lines.compactMap {
            $0.matchFirst(with: "class :\(Pattern.iegalIdentifier) BaseViewController<\(Pattern.iegalIdentifier)>")
        }.compactMap {
            $0.last(separatedBy: "class ")?.first(separatedBy: ":")
        }.map {
            Keyword(name: $0, url: url)
        }
    }.reduce([], +)
}

func filterFlows(from urls: [URL]) -> [Keyword] {
    return urls.map { url in
        url.lines.compactMap {
            $0.matchFirst(with: "class \(Pattern.iegalIdentifier): Flow")
        }.compactMap {
            $0.last(separatedBy: "class ")?.first(separatedBy: ":")
        }.map {
            Keyword(name: $0, url: url)
        }
    }.reduce([], +)
}

let main = command {
    let root = "MainFlow"
    let swiftFiles = loadSwiftFiles(root: "/Users/meng/Documents/Xcode/tipstar-ios/")
    let viewControllers = filterViewControllers(from: swiftFiles)
    let flows = filterFlows(from: swiftFiles)
    guard let rootFlow = flows.first(name: root) else {
        return
    }
    let lines = rootFlow.url.lines
    let content = rootFlow.url.content
    guard let step = content.matchFirst(with: "enum \(Pattern.iegalIdentifier): Step \\{[\\s\\S]*?\\}") else {
        return
    }
    // Find all steps in the flow.
    let steps = step.components(separatedBy: "\n").compactMap {
        $0.matchFirst(with: "case \(Pattern.iegalIdentifier)")?.last(separatedBy: "case ")
    }.compactMap {
        content.matchFirst(with: "(case .\($0)[\\s\\S]*?return[\\s\\S]*?case)|(case .\($0)[\\s\\S]*?return[\\s\\S]*?\\})")
    }.map {
        $0.components(separatedBy: "\n").dropLast()
    }.reduce([], +)

    // Find the variable names of sub view controllers
    let subViewControllers = steps.map {
        $0.match(with: "(.viewController\\(\(Pattern.iegalIdentifier)\\))|(.viewController\\(\(Pattern.iegalIdentifier), with: [\\s\\S]*?\\))")
    }.reduce([], +).compactMap {
        $0.last(separatedBy: ".viewController(")?.first(separatedBy: ",")?.first(separatedBy: ")")
    }

    // Find the variable names of sub flows
    let subFlows = steps.map {
        $0.match(with: ".flow\\(\(Pattern.iegalIdentifier), with: \(Pattern.iegalIdentifier).\(Pattern.iegalIdentifier)\\)")
    }.reduce([], +).compactMap {
        $0.last(separatedBy: ".flow(")?.first(separatedBy: ",")
    }

    (subViewControllers + subFlows).compactMap { name in
        lines.first { $0.contains(name + " =") }?.last(separatedBy: " = ")?.first(separatedBy: "(")
    }.forEach {
        print($0)
    }
}

main.run()
