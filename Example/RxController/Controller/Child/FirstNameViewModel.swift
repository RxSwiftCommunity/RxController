//
//  FirstNameViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/06/03.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Fakery
import RxCocoa
import RxSwift

class FirstNameViewModel: BaseViewModel {
    
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

    func updateFirstName() {
        parentEvents.accept(NameEvent.firstName.event(faker.name.lastName()))
    }
    
}
