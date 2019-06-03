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

struct NameEvent {
    static let firstName = RxControllerEvent.identifier()
    static let lastName = RxControllerEvent.identifier()
}

class NameViewModel: RxViewModel {
    
    let firstNameViewModel = FirstNameViewModel()
    let lastNameViewModel = LastNameViewModel()
    
    override init() {
        super.init()
        
        addChildModels(firstNameViewModel, lastNameViewModel)
    }
    
    private let faker = Faker(locale: "nb-NO")

    func updateName() {
        let firstName = faker.name.firstName()
        let lastName = faker.name.lastName()
        parentEvents.accept(InfoEvent.name.event(firstName + " " + lastName))
        events.accept(NameEvent.firstName.event(firstName))
        events.accept(NameEvent.lastName.event(lastName))
    }
    
    var name: Observable<String?> {
        return Observable.merge(
            parentEvents.value(of: InfoEvent.name),
            Observable.combineLatest(
                events.unwrappedValue(of: NameEvent.firstName),
                events.unwrappedValue(of: NameEvent.lastName)
            ).map { $0 + " " + $1 }
        )
    }
    
    var number: Observable<String?> {
        return parentEvents.value(of: InfoEvent.number)
    }
    
}
