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
        accept(event: InfoEvent.name(faker.name.name()))
    }
    
    var name: Observable<String?> {
        return parentEvents
            .filter { $0 is InfoEvent }.map { $0 as! InfoEvent }
            .filter {
                if case .name(_) = $0 {
                    return true
                }
                return false
            }.map {
                guard case let .name(name) = $0 else {
                    return nil
                }
                return name
        }
    }
    
    var number: Observable<String?> {
        return parentEvents
            .filter { $0 is InfoEvent }.map { $0 as! InfoEvent }
            .filter {
                if case .number(_) = $0 {
                    return true
                }
                return false
            }.map {
                guard case let .number(number) = $0 else {
                    return nil
                }
                return number
        }
    }
    
}
