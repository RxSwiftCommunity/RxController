//
//  ChildFlow.swift
//  RxController_Example
//
//  Created by Meng Li on 12/3/19.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxFlow

enum ChildStep: Step {
    case start
}

class ChildFlow: Flow {
    
    var root: Presentable {
        infoViewController
    }
    
    private let infoViewController = InfoViewController(viewModel: InfoViewModel())
    
    func navigate(to step: Step) -> FlowContributors {
        guard let childStep = step as? ChildStep else {
            return .none
        }
        switch childStep {
        case .start:
            return .viewController(infoViewController)
        }
    }
    
}
