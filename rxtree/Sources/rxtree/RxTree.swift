//
//  RxTree.swift
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
import Rainbow

struct Pattern {
    static let legalIdentifier = "[a-zA-Z\\_][0-9a-zA-Z\\_]*"
    static let viewController = "(.viewController\\(\(Pattern.legalIdentifier)\\))|(.viewController\\(\(Pattern.legalIdentifier), with: [\\s\\S]*?\\))"
    static let flow = ".flow\\(\(Pattern.legalIdentifier), with: \(Pattern.legalIdentifier).\(Pattern.legalIdentifier)\\)"
}

class RxTree {

    private let flows: [Keyword]
    private let viewControllers: [Keyword]

    init?(directory: String = FileManager.default.currentDirectoryPath) {
        var currentDirectory = directory + "/"
        var projects: [String] = []
        repeat {
            if let last = currentDirectory.last(separatedBy: "/") {
                currentDirectory = String(currentDirectory.dropLast(last.count + 1))
            } else {
                currentDirectory = ""
            }
            projects = currentDirectory.loadFiles(isRecursion: false).compactMap {
                $0.absoluteString
            }.map {
                $0.last == "/" ? String($0.dropLast()) : $0
            }.compactMap {
                $0.last(separatedBy: "/")?.matchFirst(with: "(\(Pattern.legalIdentifier).xcodeproj)|(\(Pattern.legalIdentifier).xcworkspace)")
            }

        } while (projects.isEmpty && !currentDirectory.isEmpty)
        guard !currentDirectory.isEmpty else {
            return nil
        }
        let swiftFiles = currentDirectory.loadSwiftFiles()

        // Load all flows
        flows = swiftFiles.map { url in
            url.lines.compactMap {
                $0.matchFirst(with: "class \(Pattern.legalIdentifier): Flow")
            }.compactMap {
                $0.last(separatedBy: "class ")?.first(separatedBy: ":")
            }.map {
                Keyword(name: $0, url: url)
            }
        }.reduce([], +)

        // Load all view controllers
        viewControllers = swiftFiles.map { url in
            url.lines.compactMap {
                $0.matchFirst(with: "class \(Pattern.legalIdentifier): BaseViewController<\(Pattern.legalIdentifier)>")
            }.compactMap {
                $0.last(separatedBy: "class ")?.first(separatedBy: ":")
            }.map {
                Keyword(name: $0, url: url)
            }
        }.reduce([], +)

    }

    func list(root: String) -> Node? {
        if flows.names.contains(root) {
            return listFlow(root: root, lastLevel: 0)
        }
        if viewControllers.names.contains(root) {
            return listViewController(root: root, lastLevel: 0)
        }
        return nil
    }

    private func listFlow(root: String, lastLevel: Int) -> Flow? {
        guard let rootFlow = flows.first(name: root) else {
            return nil
        }
        let lines = rootFlow.url.lines
        let content = rootFlow.url.content
        guard let step = content.matchFirst(with: "enum \(Pattern.legalIdentifier): Step \\{[\\s\\S]*?\\}") else {
            return nil
        }
        // Find all steps in the flow.
        let steps = step.components(separatedBy: "\n").compactMap {
            $0.matchFirst(with: "case \(Pattern.legalIdentifier)")?.last(separatedBy: "case ")
        }.compactMap {
            content.matchFirst(with: "(case .\($0)[\\s\\S]*?return[\\s\\S]*?case)|(case .\($0)[\\s\\S]*?return[\\s\\S]*?\\})")
        }

        // Find the variable names of sub view controllers
        let subViewControllers = steps.compactMap { step -> String? in
            guard
                let returnViewController = step.matchFirst(with: Pattern.viewController),
                let viewController = returnViewController.last(separatedBy: ".viewController(")?.first(separatedBy: ",")?.first(separatedBy: ")")
            else {
                return nil
            }
            var className = step.components(separatedBy: "\n").dropLast().first {
                $0.contains(viewController + " = ")
            }?.last(separatedBy: " = ")?.first(separatedBy: "(")
            if className == nil {
                className = lines.first {
                    $0.contains(viewController + " = ")
                }?.last(separatedBy: " = ")?.first(separatedBy: "(")
            }
            if className == nil {
                className = lines.compactMap {
                    $0.matchFirst(with: "\(viewController): \(Pattern.legalIdentifier)")
                }.first?.last(separatedBy: ": ")
            }
            if className == nil {
                print("[Warning] Class name not found for \(viewController), check the following code.\n)".yellow)
                step.components(separatedBy: "\n").enumerated().forEach { index, line in
                    print((index + 1).lineNumber.lightBlack + line.lightBlack)
                }
            }
            return className
        }.uniques.sorted().filter {
            viewControllers.names.contains($0)
        }.map {
            ViewController(level: lastLevel + 1, name: $0, viewControllers: [])
        }

        // Find the variable names of sub flows
        let subFlows = steps.map {
            $0.components(separatedBy: "\n").dropLast()
        }.reduce([], +).map {
            $0.match(with: Pattern.flow)
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

    private func listViewController(root: String, lastLevel: Int) -> ViewController? {
        return nil
    }

}
