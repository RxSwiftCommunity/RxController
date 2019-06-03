//
//  LastNameViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/06/03.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Fakery
import RxController
import RxSwift

class LastNameViewModel: RxViewModel {
    
    var firstName: Observable<String?> {
        return parentEvents.value(of: NameEvent.firstName)
    }
    
    var lastName: Observable<String?> {
        return parentEvents.value(of: NameEvent.lastName)
    }
    
    private let faker = Faker(locale: "nb-NO")
    
    func updateLastName() {
        parentEvents.accept(NameEvent.lastName.event(faker.name.lastName()))
    }
    
}
