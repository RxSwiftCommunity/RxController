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
}

struct Flow: Node {
    let level: Int
    let name: String
    let flows: [Flow]
    let viewControllers: [ViewController]
}

struct ViewController: Node {
    let level: Int
    let name: String
    let viewControllers: [ViewController]
}

extension Flow: CustomStringConvertible {

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

extension ViewController: CustomStringConvertible {

    var description: String {
        var indent = ""
        if level > 0 {
            indent += (0..<level - 1).map { _ in "│   "}.reduce("", +)
            indent += "├── "
        }
        return indent + name + "\n"
    }

}
