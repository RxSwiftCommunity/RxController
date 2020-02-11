//
//  RxViewModel.swift
//  RxController
//
//  Created by Meng Li on 04/09/2019.
//  Copyright (c) 2019 XFLAG. All rights reserved.
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
import RxSwift
import RxCocoa
import RxFlow

open class RxViewModel: NSObject, Stepper {
    
    public let steps = PublishRelay<Step>()
    public let events = PublishRelay<RxControllerEvent>()
    public let disposeBag = DisposeBag()
    private var cachedEvents = [RxControllerEvent]()
    
    public override init() {
        super.init()
        
        events.subscribe(onNext: { [unowned self] in
            guard $0.identifier.id != RxControllerEvent.steps.id else { return }
            let cachedEventIds = self.cachedEvents.map { $0.identifier.id }
            if let index = cachedEventIds.firstIndex(of: $0.identifier.id) {
                self.cachedEvents[index] = $0
            } else {
                self.cachedEvents.append($0)
            }
        }).disposed(by: disposeBag)
        
        let stepEvents: Observable<Step> = events.unwrappedValue(of: RxControllerEvent.steps)
        stepEvents.subscribe(onNext: { [unowned self] in
            self.steps.accept($0)
        }).disposed(by: disposeBag)
        
        steps.subscribe(onNext: { [unowned self] in
            if let parentEvents = self._parentEvents {
                parentEvents.accept(RxControllerEvent.steps.event($0))
            }
        }).disposed(by: disposeBag)
    }
    
    deinit {
        Log.debug("[DEINIT View Model] \(type(of: self))")
    }
    
    open func prepareForParentEvents() {}
    
    public func addChild(_ viewModel: RxViewModel) {
        viewModel._parentEvents = events
        republishEvents()
    }
    
    public func addChildren(_ viewModels: RxViewModel...) {
        viewModels.forEach {
            $0._parentEvents = events
        }
        republishEvents()
    }
    
    private func republishEvents() {
        cachedEvents.forEach {
            events.accept($0)
        }
    }
    
    weak var _parentEvents: PublishRelay<RxControllerEvent>? {
        didSet {
            prepareForParentEvents()
        }
    }
    
    public var parentEvents: PublishRelay<RxControllerEvent> {
        guard let events = _parentEvents else {
            Log.debug("parentEvents have NOT been prepared in \(type(of: self))!\n use prepareForParentEvents if you subscribed parentEvents.")
            return PublishRelay()
        }
        return events
    }
    
    public func removeCachedEvent(at eventIdentifier: RxControllerEvent.Identifier) {
        let cachedEventIds = cachedEvents.map { $0.identifier.id }
        if let index = cachedEventIds.firstIndex(of: eventIdentifier.id) {
            cachedEvents.remove(at: index)
        }
    }
    
    public func removeCachedEvents(_ eventIdentifiers: [RxControllerEvent.Identifier]) {
        eventIdentifiers.forEach {
            removeCachedEvent(at: $0)
        }
    }
    
    public func removeAllCachedEvents() {
        cachedEvents.removeAll()
    }
}

extension RxViewModel: RxControllerEventBinder {}

extension RxViewModel: RxControllerEventRouter {}
