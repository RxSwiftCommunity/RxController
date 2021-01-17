//
//  String+Extension.swift
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

import Foundation

extension String {

    func match(with pattern: String) -> [String] {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        guard let results = regex?.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)), !results.isEmpty else {
            return []
        }
        return results.map {
            (self as NSString).substring(with: $0.range)
        }
    }

    func matchFirst(with pattern: String) -> String? {
        return match(with: pattern).first
    }

    func last(separatedBy string: String) -> String? {
        return self.components(separatedBy: string).last
    }

    func first(separatedBy string: String) -> String? {
        return self.components(separatedBy: string).first
    }

}

extension String {

    func loadSwiftFiles() -> [URL] {
        guard let rootURL = URL(string: self) else {
            return []
        }
        return loadFiles(url: rootURL).filter {
            $0.absoluteString.hasSuffix(".swift")
        }
    }

    func loadFiles(isRecursion: Bool) -> [URL] {
        guard let rootURL = URL(string: self) else {
            return []
        }
        return loadFiles(url: rootURL, isRecursion: isRecursion)
    }

    private func loadFiles(url: URL, isRecursion: Bool = true) -> [URL] {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            return fileURLs.filter {
                !$0.absoluteString.hasSuffix(".git/") && !$0.absoluteString.hasSuffix("Pods/")
            }.map {
                $0.absoluteString.last == "/" && isRecursion ? loadFiles(url: $0) : [$0]
            }.reduce([], +)
        } catch {
            print("Error while enumerating files \(url.path): \(error.localizedDescription)")
        }
        return []
    }

}
