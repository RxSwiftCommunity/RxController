import Foundation

struct Keyword {
    let name: String
    let url: URL
}

extension Keyword: CustomStringConvertible {

    var description: String {
        name + " in " + url.absoluteString
    }

}

extension Array where Element == Keyword {

    var names: [String] {
        map { $0.name }
    }

    func first(name: String) -> Keyword? {
        let firstIndex = map { $0.name }.firstIndex(of: name)
        guard let index = firstIndex else {
            return nil
        }
        return self[index]
    }

}
