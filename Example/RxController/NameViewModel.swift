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

    func updateName() {
        accept(event: .name(faker.name.name()))
    }
    
    var name: Observable<String?> {
        return parentEvents.value(of: .name)
    }
    
    var number: Observable<String?> {
        return parentEvents.value(of: .number)
    }
    
}
