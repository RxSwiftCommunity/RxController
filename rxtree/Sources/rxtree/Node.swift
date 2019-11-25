//
//  Node.swift
//  rxtree
//
//  Created by Meng Li on 2019/11/20.
//  Copyright © 2019 XFLAG. All rights reserved.
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

import Foundation

protocol Node {
    var level: Int { get }
    var className: String { get }
    var description: String { get }
}

struct Flow: Node {
    let level: Int
    let className: String
    let flows: [Flow]
    let viewControllers: [ViewController]

    var description: String {
        let flowsDescription = flows.map {
            $0.description
        }.reduce("", +)
        let viewControllerDescription = viewControllers.map {
            $0.description
        }.reduce("", +)
        var indent = ""
        if level > 0 {
            indent += (0..<level - 1).map { _ in "│   "}.reduce("", +)
            indent += "├── "
        }
        return indent + className.lightBlue + "\n" + flowsDescription + viewControllerDescription
    }

}

struct ViewController: Node {
    let level: Int
    let className: String
    let viewControllers: [ViewController]

    var description: String {
        var indent = ""
        if level > 0 {
            indent += (0..<level - 1).map { _ in "│   "}.reduce("", +)
            indent += "├── "
        }
        return indent + className + "\n" + viewControllers.map {
            $0.description
        }.reduce([], +)
    }

}
