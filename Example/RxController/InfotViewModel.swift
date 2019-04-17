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

extension RxControllerEventType {
    static let name = RxControllerEventType(type: String.self)
    static let number = RxControllerEventType(type: String.self)
}

extension RxControllerEvent {
    static func name(_ name: String) -> RxControllerEvent {
        return RxControllerEvent(type: .name, value: name)
    }
    
    static func number(_ number: String) -> RxControllerEvent {
        return RxControllerEvent(type: .number, value: number)
    }
}

class InfoViewModel: RxViewModel {
    
    private let faker = Faker(locale: "nb-NO")
    
    var name: Observable<String?> {
        return events.value(of: .name)
    }
    
    var number: Observable<String?> {
        return events.value(of: .number)
    }
    
    func updateAll() {
        events.accept(.name(faker.name.name()))
        events.accept(.number(faker.phoneNumber.cellPhone()))
    }
    
}
