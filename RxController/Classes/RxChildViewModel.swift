//
//  RxChildViewModel.swift
//  RxController
//
//  Created by Meng Li on 04/16/2019.
//  Copyright (c) 2019 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa

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

