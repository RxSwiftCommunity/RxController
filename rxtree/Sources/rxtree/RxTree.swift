//
//  File.swift
//  
//
//  Created by Meng Li on 2019/11/20.
//

import Foundation

class RxTree {

    private let flows: [Keyword]
    private let viewControllers: [Keyword]

    init(directory: String) {
        let swiftFiles = directory.loadSwiftFiles()

        // Load all flows
        flows = swiftFiles.map { url in
            url.lines.compactMap {
                $0.matchFirst(with: "class \(Pattern.iegalIdentifier): Flow")
            }.compactMap {
                $0.last(separatedBy: "class ")?.first(separatedBy: ":")
            }.map {
                Keyword(name: $0, url: url)
            }
        }.reduce([], +)

        // Load all view controllers
        viewControllers = swiftFiles.map { url in
            url.lines.compactMap {
                $0.matchFirst(with: "class :\(Pattern.iegalIdentifier) BaseViewController<\(Pattern.iegalIdentifier)>")
            }.compactMap {
                $0.last(separatedBy: "class ")?.first(separatedBy: ":")
            }.map {
                Keyword(name: $0, url: url)
            }
        }.reduce([], +)
    }

    func listFlow(root: String, lastLevel: Int = 0) -> Flow? {
        guard let rootFlow = flows.first(name: root) else {
            return nil
        }
        let lines = rootFlow.url.lines
        let content = rootFlow.url.content
        guard let step = content.matchFirst(with: "enum \(Pattern.iegalIdentifier): Step \\{[\\s\\S]*?\\}") else {
            return nil
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
        }.compactMap { name in
            lines.first {
                $0.contains(name + " =")
            }?.last(separatedBy: " = ")?.first(separatedBy: "(")
        }.map {
            ViewController(level: lastLevel + 1, name: $0, viewControllers: [])
        }

        // Find the variable names of sub flows
        let subFlows = steps.map {
            $0.match(with: ".flow\\(\(Pattern.iegalIdentifier), with: \(Pattern.iegalIdentifier).\(Pattern.iegalIdentifier)\\)")
        }.reduce([], +).compactMap {
            $0.last(separatedBy: ".flow(")?.first(separatedBy: ",")
        }.compactMap { name in
            lines.first {
                $0.contains(name + " =")
            }?.last(separatedBy: " = ")?.first(separatedBy: "(")
        }.compactMap { name -> Flow? in
            guard let subFlow = listFlow(root: name, lastLevel: lastLevel + 1) else {
                return nil
            }
            return Flow(
                level: lastLevel + 1,
                name: name,
                flows: subFlow.flows,
                viewControllers: subFlow.viewControllers
            )
        }

        return Flow(level: lastLevel, name: root, flows: subFlows, viewControllers: subViewControllers)
    }

}
