//
//  MainFlow.swift
//  RxController_Example
//
//  Created by Meng Li on 12/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import RxFlow

enum MainStep: Step {
    case start
}

class MainFlow: Flow {
    
    var root: Presentable {
        return mainViewController
    }
    
    private let mainViewModel = MainViewModel()
    private lazy var mainViewController = MainViewController(viewModel: mainViewModel)
    
    private var navigationController: UINavigationController? {
        return mainViewController.navigationController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainStep else {
            return .none
        }
        switch step {
        case .start:
            let childFlow = ChildFlow()
            let profileFlow = ProfileFlow()
            Flows.whenReady(flow1: childFlow, flow2: profileFlow) {
                self.mainViewController.viewControllers = [$0, $1]
            }
            return .multiple(flowContributors: [
                .contribute(withNextPresentable: mainViewController, withNextStepper: mainViewModel),
                .flow(childFlow, with: ChildStep.start),
                .flow(profileFlow, with: ProfileStep.start)
            ])
        }
    }
    
}
