//
//  RxFlow+Extension.swift
//  RxController
//
//  Created by Meng Li on 2019/01/30.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxFlow

extension FlowContributors {
    
    public static func viewController<ViewModel: RxViewModel>(_ viewController: RxViewController<ViewModel>) -> FlowContributors {
        return .one(flowContributor: .viewController(viewController))
    }
    
    public static func flow(_ flow: Flow, with step: Step) -> FlowContributors {
        return .one(flowContributor: .flow(flow, with: step))
    }
    
}

extension FlowContributor {
    
    public static func viewController<ViewModel: RxViewModel>(_ viewController: RxViewController<ViewModel>) -> FlowContributor {
        return .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel)
    }
    
    public static func viewController(_ viewController: UIViewController, with viewModel: Stepper) -> FlowContributor {
        return .contribute(withNextPresentable: viewController, withNextStepper: viewModel)
    }
    
    public static func flow(_ flow: Flow, with step: Step) -> FlowContributor {
        return .contribute(withNextPresentable: flow, withNextStepper: OneStepper(withSingleStep: step))
    }
    
}

