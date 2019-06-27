//
//  NumberViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/04/16.
//  Copyright © 2019 XFLAG. All rights reserved.
//

import RxSwift
import RxController
import Fakery

class NumberViewModel: RxViewModel {
    
    private let faker = Faker(locale: "nb-NO")
    
    func updateNumber() {
        parentEvents.accept(InfoEvent.number.event(faker.phoneNumber.cellPhone()))
    }
    
    var name: Observable<String?> {
        return parentEvents.value(of: InfoEvent.name)
    }
    
    var number: Observable<String?> {
        return parentEvents.value(of: InfoEvent.number)
    }
    
}
