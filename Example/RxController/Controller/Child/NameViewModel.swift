//
//  NameViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/04/16.
//  Copyright © 2019 MuShare. All rights reserved.
//

import Fakery
import RxCocoa
import RxController
import RxSwift


struct NameEvent {
    static let firstName = RxControllerEvent.identifier()
    static let lastName = RxControllerEvent.identifier()
}

class NameViewModel: BaseViewModel {
    
    private let faker = Faker(locale: "nb-NO")
    
    private let nameRelay = BehaviorRelay<String?>(value: nil)
    
    override func prepareForParentEvents() {
        bindParentEvents(to: nameRelay, with: InfoEvent.name)
    }

    var name: Observable<String?> {
        Observable.merge(
            nameRelay.asObservable(),
            Observable
                .combineLatest(
                    events.unwrappedValue(of: NameEvent.firstName),
                    events.unwrappedValue(of: NameEvent.lastName)
                )
                .map { $0 + " " + $1 }
        )
    }
    
    var number: Observable<String?> {
        parentEvents.value(of: InfoEvent.number)
    }
    
    func updateName() {
        let firstName = faker.name.firstName()
        let lastName = faker.name.lastName()
        parentEvents.accept(InfoEvent.name.event(firstName + " " + lastName))
        events.accept(NameEvent.firstName.event(firstName))
        events.accept(NameEvent.lastName.event(lastName))
    }

    
}
