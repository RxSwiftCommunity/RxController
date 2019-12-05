//
//  FirendsViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 12/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import RxCocoa
import RxDataSourcesSingleSection
import RxSwift
import Fakery

class FriendsViewModel: BaseViewModel {
    
    private let nameRealy = BehaviorRelay<String?>(value: nil)
    private let firindsRelay = BehaviorRelay<[String]>(value: [])
    
    init(name: String) {
        super.init()
        nameRealy.accept(name)
        let faker = Faker(locale: "nb-NO")
        firindsRelay.accept((0...Int.random(in: 5...10)).map { _ in faker.name.name() })
    }
    
    var title: Observable<String> {
        nameRealy.filter { $0 != nil }.map {
            "\($0!)'s friends"
        }
    }
    
    var friendSection: Observable<SingleSection<Selection>> {
        firindsRelay.map {
            $0.map { Selection(title: $0, accessory: .disclosureIndicator) }
        }.map {
            SingleSection.create($0)
        }
    }
    
    func pick(at index: Int) {
        guard 0..<firindsRelay.value.count ~= index else {
            return
        }
        steps.accept(FriendsStep.profile(firindsRelay.value[index]))
    }
    
}
