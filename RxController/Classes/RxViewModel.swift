//
//  RxViewModel.swift
//  RxController
//
//  Created by Meng Li on 04/09/2019.
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

import RxSwift
import RxCocoa
import RxFlow

open class RxViewModel: NSObject, Stepper {
    
    public let steps = PublishRelay<Step>()
    public let events = BehaviorRelay<RxControllerEvent>(value: RxControllerEvent.none)
    public let disposeBag = DisposeBag()
    
    public override init() {
        super.init()
        
        let stepEvents: Observable<Step> = events.unwrappedValue(of: RxControllerEvent.steps)
        stepEvents.subscribe(onNext: { [unowned self] in
            self.steps.accept($0)
        }).disposed(by: disposeBag)
    }
    
    deinit {
        Log.debug("[DEINIT View Model] \(type(of: self))")
    }
    
    open func prepareForParentEvents() {}
    
    public func addChildModel(_ viewModel: RxViewModel) {
        viewModel._parentEvents = events
    }
    
    public func addChildModels(_ viewModels: RxViewModel...) {
        viewModels.forEach {
            $0._parentEvents = events
        }
    }
    
    weak var _parentEvents: BehaviorRelay<RxControllerEvent>? {
        didSet {
            prepareForParentEvents()
        }
    }
    
    public var parentEvents: BehaviorRelay<RxControllerEvent> {
        guard let events = _parentEvents else {
            Log.debug("parentEvents have NOT been prepared in \(type(of: self))!\n use prepareForParentEvents if you subscribed parentEvents.")
            return BehaviorRelay(value: RxControllerEvent.none)
        }
        return events
    }
    
    public func acceptStepsEvent(_ step: Step) {
        parentEvents.accept(RxControllerEvent.steps.event(step))
    }
    
}

