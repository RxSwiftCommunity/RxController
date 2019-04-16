//
//  NameViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/04/16.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa
import RxController
import Fakery

class NameViewModel: RxChildViewModel {
    
    private let faker = Faker(locale: "nb-NO")
    
    let name = BehaviorRelay<String?>(value: "Alice")
    let number = BehaviorRelay<String?>(value: "1234567890")
    
    func updateName() {
        name.accept(faker.name.name())
    }
    
}
