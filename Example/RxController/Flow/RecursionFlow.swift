//
//  RecursionFlow.swift
//  RxController_Example
//
//  Created by Meng Li on 12/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import RxFlow

enum RecursionStep: Step {
    case start
    case profile(String)
    case friends(String)
}

class RecursionFlow: Flow {
    
    var root: Presentable {
        profileViewController
    }
    
    private let profileViewController = ProfileViewController(viewModel: .init())
    
    private var navigationController: UINavigationController? {
        profileViewController.navigationController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let recursionStep = step as? RecursionStep else {
            return .none
        }
        switch recursionStep {
        case .start:
            return .viewController(profileViewController)
        case .profile(let name):
            let profileViewController = ProfileViewController(viewModel: .init(name: name))
            navigationController?.pushViewController(profileViewController, animated: true)
            return .viewController(profileViewController)
        case .friends(let name):
            let friendsViewController = FriendsViewController(viewModel: .init(name: name))
            navigationController?.pushViewController(friendsViewController, animated: true)
            return .viewController(friendsViewController)
        }
    }
    
}
