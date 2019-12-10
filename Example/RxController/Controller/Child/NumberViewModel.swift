//
//  NumberViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/04/16.
//  Copyright © 2019 XFLAG. All rights reserved.
//

import Fakery
import RxCocoa
import RxSwift

class NumberViewModel: BaseViewModel {
    
    private let faker = Faker(locale: "nb-NO")
    
    private let numberRelay = BehaviorRelay<String?>(value: nil)
    
    override func prepareForParentEvents() {
        bindParentEvents(to: numberRelay, with: InfoEvent.number)
    }
    
    var number: Observable<String?> {
        numberRelay.asObservable()
    }
    
    func updateNumber() {
        parentEvents.accept(InfoEvent.number.event(faker.phoneNumber.cellPhone()))
    }
    
}
