//
//  AppFlow.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/04/09.
//  Copyright © 2019 XFLAG. All rights reserved.
//

import RxFlow

enum AppStep: Step {
    case main
}

class AppFlow: Flow {
    
    var root: Presentable {
        return rootWindow
    }
    
    private let rootWindow: UIWindow
    
    private lazy var navigationController = UINavigationController()
    
    init(window: UIWindow) {
        rootWindow = window
        rootWindow.backgroundColor = .white
        rootWindow.rootViewController = navigationController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let appStep = step as? AppStep else {
            return  .none
        }
        switch appStep {
        case .main:
            let mainFlow = MainFlow()
            Flows.whenReady(flow1: mainFlow) { [unowned self] in
                self.navigationController.viewControllers = [$0]
            }
            return .flow(mainFlow, with: MainStep.start)
        }
    }
    
}
