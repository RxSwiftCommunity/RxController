import Commander
import Foundation

let main = command { (root: String) in
    let rxtree = RxTree(directory: "/Users/meng/Documents/Xcode/tipstar-ios/")
    if let node = rxtree.list(root: root) {
        print(node.description)
    }
}
main.run()
