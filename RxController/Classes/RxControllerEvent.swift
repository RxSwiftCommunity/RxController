//
//  RxControllerEvent.swift
//  RxController
//
//  Created by Meng Li on 04/16/2019.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift

public protocol RxControllerEventValue {}

extension Int: RxControllerEventValue {}
extension Int8: RxControllerEventValue {}
extension Int16: RxControllerEventValue {}
extension Int32: RxControllerEventValue {}
extension Int64: RxControllerEventValue {}
extension UInt: RxControllerEventValue {}
extension UInt8: RxControllerEventValue {}
extension UInt16: RxControllerEventValue {}
extension UInt32: RxControllerEventValue {}
extension UInt64: RxControllerEventValue {}
extension Float: RxControllerEventValue {}
extension Double: RxControllerEventValue {}
extension String: RxControllerEventValue {}
extension Bool: RxControllerEventValue {}
extension CGFloat: RxControllerEventValue {}
extension CGSize: RxControllerEventValue {}
extension CGPoint: RxControllerEventValue {}
extension CGRect: RxControllerEventValue {}

public struct RxControllerEventType {
    var identifier: String
    var type: RxControllerEventValue.Type
 
    public init(type: RxControllerEventValue.Type) {
        self.identifier = UUID().uuidString
        self.type = type
    }
    
    public func event(_ value: RxControllerEventValue) -> RxControllerEvent {
        return RxControllerEvent(identifier: identifier, value: value)
    }
}

public struct RxControllerEvent {
    
    var identifier: String
    var value: RxControllerEventValue
    
    init(identifier: String, value: RxControllerEventValue) {
        self.identifier = identifier
        self.value = value
    }

    init<Value: RxControllerEventValue>(type: RxControllerEventType, value: Value) {
        self.identifier = type.identifier
        self.value = value
    }
    
    static let none = RxControllerEvent(identifier: "none", value: "none")
    
}

extension ObservableType where E == RxControllerEvent {

    public func value<Value: RxControllerEventValue>(of type: RxControllerEventType) -> Observable<Value?> {
        return filter {
            $0.identifier == type.identifier
        }.map {
            $0.value as? Value
        }
    }
    
    public func value<Value: RxControllerEventValue>(of type: RxControllerEventType) -> Observable<Value> {
        return filter {
            $0.identifier == type.identifier
        }.filter {
            $0.value is Value
        }.map {
            $0.value as! Value
        }
    }
    
}
