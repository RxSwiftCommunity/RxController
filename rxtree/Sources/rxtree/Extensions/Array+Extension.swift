//
//  File.swift
//  
//
//  Created by Meng Li on 2019/11/22.
//

import Foundation

extension Array where Element: Hashable {

    var uniques: Array {
        reduce(Set<Element>()) {
            var result = $0
            result.insert($1)
            return result
        }.reduce([Element]()) {
            $0 + [$1]
        }
    }

}
