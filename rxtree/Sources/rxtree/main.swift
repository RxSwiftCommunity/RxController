//
//  main.swift
//  rxtree
//
//  Created by Meng Li on 2019/11/19.
//  Copyright © 2019 MuShare. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Commander
import Foundation

let main = command(
    Argument<String>("root", description: "Root node, a flow or a view controller."),
    Option("dir", default: "", description: "Directory to scan the Xcode project."),
    Option("maxLevels", default: "10", description: "Max levels.")
) { root, dir, maxLevels in
    guard let maxLevels = Int(maxLevels), maxLevels > 0 else {
        print("maxLevels should be a number greater than 0.")
        return
    }
    let rootDir = dir.isEmpty ? FileManager.default.currentDirectoryPath : dir
    guard let rxtree = RxTree(directory: rootDir, maxLevels: maxLevels) else {
        print("Xcode project not found.".red)
        return
    }
    if let node = rxtree.list(root: root) {
        print(node.description)
    } else {
        print("Node not found for name: \(root)".red)
    }
}

main.run()
