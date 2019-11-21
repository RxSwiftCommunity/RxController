import Commander
import Foundation

let main = command(
    Argument<String>("root", description: "Root node, a flow or a view controller."),
    Option("dir", default: "", description: "Directory to scan the Xcode project.")
) { root, dir in
    guard let rxtree = dir.isEmpty ? RxTree() : RxTree(directory: dir) else {
        print("Xcode project not found.")
        return
    }
    if let node = rxtree.list(root: root) {
        print(node.description)
    }
}

main.run()
