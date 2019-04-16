//
//  RxViewModel.swift
//  RxController
//
//  Created by Meng Li on 04/09/2019.
//  Copyright (c) 2019 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow

public protocol RxEvent {}

struct NoneEvent: RxEvent, Equatable {}

open class RxViewModel: NSObject, Stepper {
    
    public let steps = PublishRelay<Step>()
    public let events = PublishRelay<RxEvent>()
    public let disposeBag = DisposeBag()
    
    deinit {
        Log.debug("[DEINIT View Model] \(type(of: self))")
    }
    
}


open class RxChildViewModel: RxViewModel {
    
    weak var _parentEvents: PublishRelay<RxEvent>?
    
    public func accept(event: RxEvent) {
        _parentEvents?.accept(event)
    }
    
    public var parentEvents: Observable<RxEvent> {
        guard let events = _parentEvents else {
            return Observable.just(NoneEvent())
        }
        return events.asObservable()
    }
    
}
