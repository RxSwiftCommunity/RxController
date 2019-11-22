import Foundation

extension URL {

    var content: String {
        var data = ""
        do {
            data = try String(contentsOf: self, encoding: .utf8)
        } catch {
            print("Error while reading file \(self.path): \(error.localizedDescription)")
        }
        return data
    }

    var lines: [String] {
        return content.components(separatedBy: .newlines)
    }

}
