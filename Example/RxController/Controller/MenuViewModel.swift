//
//  MenuViewModel.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/06/21.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import RxCocoa
import RxController
import RxDataSourcesSingleSection
import RxSwift

private extension Selection {
    static let childController = Selection(title: "Child View Controller Test")
}

class MenuViewModel: RxViewModel {
    
    private let selectionsRelay = BehaviorRelay<[Selection]>(value: [.childController])
    
    var selectionSection: Observable<SingleSection<Selection>> {
        return selectionsRelay.map {
            SingleSection.create($0)
        }
    }
    
    func pick(at index: Int) {
        guard 0..<selectionsRelay.value.count ~= index else {
            return
        }
        switch selectionsRelay.value[index] {
        case .childController:
            steps.accept(AppStep.child)
        default:
            break
        }
    }
    
}
