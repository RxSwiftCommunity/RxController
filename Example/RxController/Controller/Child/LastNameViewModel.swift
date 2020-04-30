//
//  LastNameViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/06/03.
//  Copyright © 2019 MuShare. All rights reserved.
//

import Fakery
import RxCocoa
import RxSwift

class LastNameViewModel: BaseViewModel {
    
    private let faker = Faker(locale: "nb-NO")
    
    private let firstNameRelay = BehaviorRelay<String?>(value: nil)
    private let lastNameRelay = BehaviorRelay<String?>(value: nil)
    
    override func prepareForParentEvents() {
        bindParentEvents(to: firstNameRelay, with: NameEvent.firstName)
        bindParentEvents(to: lastNameRelay, with: NameEvent.lastName)
    }
    
    var firstName: Observable<String?> {
        firstNameRelay.asObservable()
    }
    
    var lastName: Observable<String?> {
        lastNameRelay.asObservable()
    }

    func updateLastName() {
        parentEvents.accept(NameEvent.lastName.event(faker.name.lastName()))
    }
    
}
