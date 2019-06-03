//
//  FirstNameViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/06/03.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Fakery
import RxController
import RxSwift

class FirstNameViewModel: RxViewModel {
    
    var firstName: Observable<String?> {
        return parentEvents.value(of: NameEvent.firstName)
    }
    
    var lastName: Observable<String?> {
        return parentEvents.value(of: NameEvent.lastName)
    }
    
    private let faker = Faker(locale: "nb-NO")
    
    func updateFirstName() {
        parentEvents.accept(NameEvent.firstName.event(faker.name.lastName()))
    }
    
}
