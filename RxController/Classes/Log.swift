//
//  Log.swift
//  RxController
//
//  Created by Meng Li on 04/01/2019.
//  Copyright (c) 2019 MuShare. All rights reserved.
//

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

