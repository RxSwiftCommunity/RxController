//
//  RxControllerEventBinder.swift
//  RxController
//
//  Created by Meng Li on 08/07/2019.
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

import RxCocoa
import RxSwift

public protocol RxControllerEventBinder: class {
    var events: PublishRelay<RxControllerEvent> { get }
    var parentEvents: PublishRelay<RxControllerEvent> { get }
    var disposeBag: DisposeBag { get }
}

extension RxControllerEventBinder {
    
    public func bindToEvents<O: ObservableType>(from observable: O, with identifier: RxControllerEvent.Identifier) {
        observable.subscribe(onNext: { [unowned self] in
            self.events.accept(identifier.event($0))
        }).disposed(by: disposeBag)
    }
    
    public func bindToParentEvents<O: ObservableType>(from observable: O, with identifier: RxControllerEvent.Identifier) {
        observable.subscribe(onNext: { [unowned self] in
            self.parentEvents.accept(identifier.event($0))
        }).disposed(by: disposeBag)
    }
    
    public func bindEvents<T>(to relay: BehaviorRelay<T?>, with identifier: RxControllerEvent.Identifier) {
        events.value(of: identifier).bind(to: relay).disposed(by: disposeBag)
    }
    
    public func bindEvents<T>(to relay: PublishRelay<T?>, with identifier: RxControllerEvent.Identifier) {
        events.value(of: identifier).bind(to: relay).disposed(by: disposeBag)
    }
    
    public func bindEvents<T, O: ObserverType>(to observer: O, with identifier: RxControllerEvent.Identifier) where O.Element == T? {
        events.value(of: identifier, type: T.self).bind(to: observer).disposed(by: disposeBag)
    }
    
    public func bindEvents<T>(to relay: BehaviorRelay<T>, with identifier: RxControllerEvent.Identifier) {
        events.unwrappedValue(of: identifier).bind(to: relay).disposed(by: disposeBag)
    }
    
    public func bindEvents<T>(to relay: PublishRelay<T>, with identifier: RxControllerEvent.Identifier) {
        events.unwrappedValue(of: identifier).bind(to: relay).disposed(by: disposeBag)
    }
    
    public func bindEvents<T, O: ObserverType>(to observer: O, with identifier: RxControllerEvent.Identifier) where O.Element == T {
        events.unwrappedValue(of: identifier, type: T.self).bind(to: observer).disposed(by: disposeBag)
    }
    
    public func bindParentEvents<T>(to relay: BehaviorRelay<T?>, with identifier: RxControllerEvent.Identifier) {
        parentEvents.value(of: identifier).bind(to: relay).disposed(by: disposeBag)
    }
    
    public func bindParentEvents<T>(to relay: PublishRelay<T?>, with identifier: RxControllerEvent.Identifier) {
        parentEvents.value(of: identifier).bind(to: relay).disposed(by: disposeBag)
    }
    
    public func bindParentEvents<T, O: ObserverType>(to observer: O, with identifier: RxControllerEvent.Identifier) where O.Element == T? {
        parentEvents.value(of: identifier, type: T.self).bind(to: observer).disposed(by: disposeBag)
    }
    
    public func bindParentEvents<T>(to relay: BehaviorRelay<T>, with identifier: RxControllerEvent.Identifier) {
        parentEvents.unwrappedValue(of: identifier).bind(to: relay).disposed(by: disposeBag)
    }
    
    public func bindParentEvents<T>(to relay: PublishRelay<T>, with identifier: RxControllerEvent.Identifier) {
        parentEvents.unwrappedValue(of: identifier).bind(to: relay).disposed(by: disposeBag)
    }
    
    public func bindParentEvents<T, O: ObserverType>(to observer: O, with identifier: RxControllerEvent.Identifier) where O.Element == T {
        parentEvents.unwrappedValue(of: identifier, type: T.self).bind(to: observer).disposed(by: disposeBag)
    }
    
}
