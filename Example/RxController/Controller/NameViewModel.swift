//
//  NameViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/04/16.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift
import RxController
import Fakery

class NameViewModel: RxChildViewModel {
    
    private let faker = Faker(locale: "nb-NO")

    func updateName() {
        accept(event: InfoEvent.name.event(faker.name.name()))
    }
    
    var name: Observable<String?> {
        return parentEvents.value(of: InfoEvent.name)
    }
    
    var number: Observable<String?> {
        return parentEvents.value(of: InfoEvent.number)
    }
    
}
