//
//  ProfileFlow.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/12/5.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxFlow

enum ProfileStep: Step {
    case start
    case friends(String)
}

class ProfileFlow: Flow {
    
    var root: Presentable {
        profileViewController
    }
    
    private let profileViewController: ProfileViewController
    
    init(name: String? = nil) {
        profileViewController = ProfileViewController(viewModel: .init(name: name))
    }
    
    private var navigationController: UINavigationController? {
        profileViewController.navigationController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let profileStep = step as? ProfileStep else {
            return .none
        }
        switch profileStep {
        case .start:
            return .viewController(profileViewController)
        case .friends(let name):
            let friendsFlow = FriendsFlow(name: name)
            Flows.whenReady(flow1: friendsFlow) {
                self.navigationController?.pushViewController($0, animated: true)
            }
            return .flow(friendsFlow, with: FriendsStep.start)
        }
    }
    
}
