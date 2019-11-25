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
    static let addChild = "addChild\\(\(Pattern.legalIdentifier), to: \(Pattern.legalIdentifier)\\)"
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

    // Search class name by property name from lines of code
    private func searchClassName(for name: String, in lines: [String]) -> String? {
        var className: String? = nil
        // Search class name from code with pattern `xxxFlow = XxxFlow`
        if className == nil {
            className = lines.first {
                $0.contains(name + " = ")
            }?.last(separatedBy: " = ")?.first(separatedBy: "(")
        }
        // Search class name from lines except all step cases with pattern `xxxFlow: XxxFlow`
        if className == nil {
            className = lines.compactMap {
                $0.matchFirst(with: "\(name): \(Pattern.legalIdentifier)")
            }.first?.last(separatedBy: ": ")
        }
        return className
    }

}

// List flow related methods.
extension RxTree {

    private func listFlow(root: String, lastLevel: Int) -> Flow? {
        guard let rootFlow = flows.first(name: root) else {
            return nil
        }

        let content = rootFlow.url.content
        guard let stepName = content.matchFirst(with: "enum \(Pattern.legalIdentifier): Step \\{[\\s\\S]*?\\}") else {
            return nil
        }
        // Find all steps in the flow.
        let steps = stepName.components(separatedBy: "\n").compactMap {
            $0.matchFirst(with: "case \(Pattern.legalIdentifier)")?.last(separatedBy: "case ")
        }.compactMap {
            content.matchFirst(with: "(case .\($0)[\\s\\S]*?return[\\s\\S]*?case)|(case .\($0)[\\s\\S]*?return[\\s\\S]*?\\})")
        }

        let linesOfSteps = steps.map {
            $0.components(separatedBy: "/")
        }.reduce([], +)
        let linesExceptSteps = rootFlow.url.lines.filter {
            !linesOfSteps.contains($0)
        }

        // Find class names of sub view controllers
        let subViewControllers = steps.compactMap { step in
            step.match(with: Pattern.viewController).compactMap {
                $0.last(separatedBy: ".viewController(")?.first(separatedBy: ",")?.first(separatedBy: ")")
            }.compactMap {
                searchClassName(for: $0, step: step, linesExceptSteps: linesExceptSteps, rootFlow: rootFlow)
            }
        }.reduce([], +).uniques.sorted().filter {
            viewControllers.names.contains($0)
        }.compactMap {
            listViewController(root: $0, lastLevel: lastLevel + 1)
        }

        // Find class names of sub flows
        let subFlows = steps.compactMap { step in
            step.match(with: Pattern.flow).compactMap {
                $0.last(separatedBy: ".flow(")?.first(separatedBy: ",")
            }.compactMap {
                searchClassName(for: $0, step: step, linesExceptSteps: linesExceptSteps, rootFlow: rootFlow)
            }
        }.reduce([], +).uniques.sorted().filter {
            flows.names.contains($0)
        }.compactMap { className -> Flow? in
            guard let subFlow = listFlow(root: className, lastLevel: lastLevel + 1) else {
                return nil
            }
            return Flow(
                level: lastLevel + 1,
                className: className,
                flows: subFlow.flows,
                viewControllers: subFlow.viewControllers
            )
        }

        return Flow(level: lastLevel, className: root, flows: subFlows, viewControllers: subViewControllers)
    }

    private func searchClassName(for name: String, step: String, linesExceptSteps: [String], rootFlow: Keyword) -> String? {
        // Search flow name from `case` to `return` at first.
        let classNameInStep = step.components(separatedBy: "\n").dropLast().first {
            $0.contains(name + " = ")
        }?.last(separatedBy: " = ")?.first(separatedBy: "(")
        if classNameInStep != nil {
            return classNameInStep
        }
        // Search flow name from lines except step.
        let classNameExceptStep = searchClassName(for: name, in: linesExceptSteps)
        if classNameExceptStep != nil {
            return classNameExceptStep
        }
        // Class name not found, print warning.
        print("[Warning] Class name not found for \(name), check the code in \(rootFlow.url.absoluteString).\n".yellow)
        return nil
    }

}

extension RxTree {

    private func listViewController(root: String, lastLevel: Int) -> ViewController? {
        guard let rootViewController = viewControllers.first(name: root) else {
            return nil
        }
        let content = rootViewController.url.content
        let lines = content.components(separatedBy: "\n")
        let childViewControllers = content.match(with: Pattern.addChild).compactMap {
            $0.last(separatedBy: "(")?.first(separatedBy: ",")
        }.compactMap {
            searchClassName(for: $0, in: lines)
        }.compactMap { className -> ViewController? in
            guard let childViewController = listViewController(root: className, lastLevel: lastLevel + 1) else {
                return nil
            }
            return ViewController(
                level: lastLevel + 1,
                className: className,
                viewControllers: childViewController.viewControllers
            )
        }
        return ViewController(level: lastLevel, className: root, viewControllers: childViewControllers)
    }

}
