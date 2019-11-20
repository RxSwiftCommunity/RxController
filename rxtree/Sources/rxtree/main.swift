import Commander
import Foundation

struct Pattern {
    static let iegalIdentifier = "[a-zA-Z\\_][0-9a-zA-Z\\_]*"
}

let main = command {
    let root = "MainFlow"
    let rxtree = RxTree(directory: "/Users/meng/Documents/Xcode/tipstar-ios/")
    let flow = rxtree.listFlow(root: root)
    print(flow.description)
}

main.run()
