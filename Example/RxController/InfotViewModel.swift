//
//  InfoViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/04/09.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa
import RxController

enum InfoEvent: RxEvent {
    case all(name: String, number: String)
    case name(String)
    case number(String)
}

class InfoViewModel: RxViewModel {
    
    override init() {
        super.init()
    }
    
    var name: Observable<String?> {
        return events.map {
            guard let events = $0 as? InfoEvent, case let .name(name) = events else {
                return nil
            }
            return name
        }
    }
    
    var number: Observable<String?> {
        return Observable.just("1234567890")
    }
    
}
