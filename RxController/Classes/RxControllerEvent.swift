//
//  RxControllerEvent.swift
//  RxController
//
//  Created by Meng Li on 04/16/2019.
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
import RxCocoa
import RxSwift

public struct RxControllerEvent {
    
    public struct Identifier {
        var id: String
        
        static let none = Identifier(id: "none")
        
        public func event(_ value: Any?) -> RxControllerEvent {
            return RxControllerEvent(identifier: self, value: value)
        }
    }
    
    var identifier: Identifier
    var value: Any?
    
    init(identifier: Identifier, value: Any?) {
        self.identifier = identifier
        self.value = value
    }

    static let none = RxControllerEvent(identifier: .none, value: nil)
    static let steps = RxControllerEvent.identifier()
    
    public static func identifier() -> Identifier {
        return Identifier(id: UUID().uuidString)
    }
    
}

extension ObservableType where Element == RxControllerEvent {
    
    public func value<T>(of identifier: RxControllerEvent.Identifier, type: T.Type = T.self) -> Observable<T?> {
        return observeOn(MainScheduler.asyncInstance).filter {
            $0.identifier.id == identifier.id
        }.map {
            $0.value as? T
        }
    }
    
    public func unwrappedValue<T>(of identifier: RxControllerEvent.Identifier, type: T.Type = T.self) -> Observable<T> {
        return value(of: identifier).filter { $0 != nil }.map { $0! }
    }

}
