//
//  InfoViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/04/09.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa
import RxController
import Fakery

enum InfoEvent: RxControllerEvent {
    case name(String)
    case number(String)
}

class InfoViewModel: RxViewModel {
    
    private let faker = Faker(locale: "nb-NO")
    
    override init() {
        super.init()
    }
    
    var name: Observable<String?> {
        return events(by: InfoEvent.self)
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
        return events(by: InfoEvent.self)
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
    
    func updateAll() {
        events.accept(InfoEvent.name(faker.name.name()))
        events.accept(InfoEvent.number(faker.phoneNumber.cellPhone()))
    }
    
}
