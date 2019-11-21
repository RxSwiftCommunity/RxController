//
//  File.swift
//  
//
//  Created by Meng Li on 2019/11/20.
//

import Foundation

protocol Node {
    var level: Int { get }
    var name: String { get }
    var description: String { get }
}

struct Flow: Node {
    let level: Int
    let name: String
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
        return indent + name + "\n" + flowsDescription + viewControllerDescription
    }

}

struct ViewController: Node {
    let level: Int
    let name: String
    let viewControllers: [ViewController]

    var description: String {
        var indent = ""
        if level > 0 {
            indent += (0..<level - 1).map { _ in "│   "}.reduce("", +)
            indent += "├── "
        }
        return indent + name + "\n"
    }

}
