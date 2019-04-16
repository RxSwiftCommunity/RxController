//
//  RxControllerEvent.swift
//  RxController
//
//  Created by Meng Li on 04/16/2019.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift

public protocol RxControllerEvent {

}

enum NoneEvent: RxControllerEvent, Equatable {
    case none
}

extension ObservableType where E == RxControllerEvent {
    
    func filter<Event: RxControllerEvent>(by type: Event.Type) -> Observable<Event> {
        return filter { $0 is Event }.map { $0 as! Event }
    }
    
}
