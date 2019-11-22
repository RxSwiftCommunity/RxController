//
//  File.swift
//  
//
//  Created by Meng Li on 2019/11/22.
//

import Foundation

extension Int {

    var lineNumber: String {
        if self < 10 {
            return "  \(self)  "
        }
        if self < 100 {
            return " \(self)  "
        }
        return "\(self)  "
    }

}
