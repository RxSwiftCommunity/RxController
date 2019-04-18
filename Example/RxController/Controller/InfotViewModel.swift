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
import Fakery

struct InfoEvent {
    static let name = RxControllerEventType(type: String.self)
    static let number = RxControllerEventType(type: String.self)
}

class InfoViewModel: RxViewModel {
    
    private let faker = Faker(locale: "nb-NO")
    
    var name: Observable<String?> {
        return events.value(of: InfoEvent.name)
    }
    
    var number: Observable<String?> {
        return events.value(of: InfoEvent.number)
    }
    
    func updateAll() {
        events.accept(InfoEvent.name.event(nil))
//        events.accept(InfoEvent.name.event(faker.name.name()))
        events.accept(InfoEvent.number.event(faker.phoneNumber.cellPhone()))
    }
    
}
