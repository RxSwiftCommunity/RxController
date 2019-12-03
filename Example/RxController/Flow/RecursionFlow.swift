//
//  RecursionFlow.swift
//  RxController_Example
//
//  Created by Meng Li on 12/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import RxFlow

enum RecursionStep: Step {
    case profile
}

class RecursionFlow: Flow {
    
    var root: Presentable {
        profileViewController
    }
    
    private let profileViewController = ProfileViewController(viewModel: .init())
    
    func navigate(to step: Step) -> FlowContributors {
        guard let recursionStep = step as? RecursionStep else {
            return .none
        }
        switch recursionStep {
        case .profile:
            return .viewController(profileViewController)
        }
    }
    
}
