//
//  RxControllerEvent.swift
//  RxController
//
//  Created by Meng Li on 04/16/2019.
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

import RxSwift

public struct RxControllerEventType {
    
    var identifier: String
    var type: Any.Type
 
    public init(type: Any.Type) {
        self.identifier = UUID().uuidString
        self.type = type
    }
    
    public func event(_ value: Any?) -> RxControllerEvent {
        return RxControllerEvent(identifier: identifier, value: value)
    }
    
}

public struct RxControllerEvent {
    
    var identifier: String
    var value: Any?
    
    init(identifier: String, value: Any?) {
        self.identifier = identifier
        self.value = value
    }

    init<Value>(type: RxControllerEventType, value: Value) {
        self.identifier = type.identifier
        self.value = value
    }
    
    static let none = RxControllerEvent(identifier: "none", value: "none")
    
}

extension ObservableType where E == RxControllerEvent {

    public func value<Value>(of type: RxControllerEventType) -> Observable<Value?> {
        return filter {
            $0.identifier == type.identifier
        }.map {
            $0.value as? Value
        }
    }
    
    public func valueUnwrap<Value>(of type: RxControllerEventType) -> Observable<Value> {
        return value(of: type).filter { $0 != nil }.map { $0! }
    }
    
}
