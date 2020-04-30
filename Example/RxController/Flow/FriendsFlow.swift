//
//  FriendsFlow.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/12/5.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxFlow

enum FriendsStep: Step {
    case start
    case profile(String)
}

class FriendsFlow: Flow {
    
    var root: Presentable {
        friendsViewController
    }
    
    private let friendsViewController: FriendsViewController
    
    init(name: String) {
        friendsViewController = FriendsViewController(viewModel: .init(name: name))
    }
    
    private var navigationController: UINavigationController? {
        friendsViewController.navigationController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let friendsStep = step as? FriendsStep else {
            return .none
        }
        switch friendsStep {
        case .start:
            return .viewController(friendsViewController)
        case .profile(let name):
            let profileFlow = ProfileFlow(name: name)
            Flows.whenReady(flow1: profileFlow) {
                self.navigationController?.pushViewController($0, animated: true)
            }
            return .flow(profileFlow, with: ProfileStep.start)
        }
    }
    
}
