//
//  Log.swift
//  RxController
//
//  Created by Meng Li on 04/01/2019.
//  Copyright (c) 2019 MuShare. All rights reserved.
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

struct Log {
    
    static func debug(_ message: String, tag: String = "", tags:[String] = []) {
        output(tag: tag, tags: tags, message: message)
    }
    
    private static func createTagString(_ tag:String, _ tags: [String]) -> String {
        if !tag.isEmpty {
            return "[\(tag)] "
        }
        
        if tags.isEmpty {
            return " "
        } else {
            return "[" + tags.joined(separator: "][") + "] "
        }
    }
    
    private static func output(tag: String, tags:[String], message: String) {
        #if DEBUG
        NSLog("RxController: " + createTagString(tag, tags) + message)
        #endif
    }
    
}

