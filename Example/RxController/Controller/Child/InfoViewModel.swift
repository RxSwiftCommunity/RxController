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

struct InfoEvent {
    static let name = RxControllerEvent.identifier()
    static let number = RxControllerEvent.identifier()
}

class InfoViewModel: BaseViewModel {
    
    private let faker = Faker(locale: "nb-NO")
    
    override init() {
        super.init()
        
        viewDidLoad.subscribe(onNext: { print("viewDidLoad") }).disposed(by: disposeBag)
        viewWillAppear.subscribe(onNext: { print("viewWillAppear") }).disposed(by: disposeBag)
        viewWillDisappear.subscribe(onNext: { print("viewWillDisappear") }).disposed(by: disposeBag)
        viewDidAppear.subscribe(onNext: { print("viewDidAppear") }).disposed(by: disposeBag)
        viewDidDisappear.subscribe(onNext: { print("viewDidDisappear") }).disposed(by: disposeBag)
    }
    
    var name: Observable<String?> {
        events.value(of: InfoEvent.name)
    }
    
    var number: Observable<String?> {
        events.value(of: InfoEvent.number)
    }
    
    func updateAll() {
        events.accept(InfoEvent.name.event(faker.name.name()))
        events.accept(InfoEvent.number.event(faker.phoneNumber.cellPhone()))
    }

}
