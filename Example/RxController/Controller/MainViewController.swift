//
//  MainViewController.swift
//  RxController_Example
//
//  Created by Meng Li on 12/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//


import RxSwift

enum MainTabType: Int {
    case child = 0
    case recursion
    
    var tabTitle: String? {
        switch self {
        case .child:
            return "Child"
        case .recursion:
            return "Recursion"
        }
    }
    
    var navigationTitle: String? {
        switch self {
        case .child:
            return "Child View Controller Demo"
        case .recursion:
            return "Recursion Test"
        }
    }
}

class MainViewController: UITabBarController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var viewControllers: [UIViewController]? {
        didSet {
            guard let viewControllers = viewControllers, viewControllers.count > 0 else {
                return
            }
            for (index, viewController) in viewControllers.enumerated() {
                let type = MainTabType(rawValue: index)
                viewController.tabBarItem = UITabBarItem(title: type?.tabTitle, image: nil, tag: index)
            }
            updateNavigationBar(with: .child)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    private func updateNavigationBar(with type: MainTabType) {
        title = type.navigationTitle
    }
    
}

extension MainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tabType = MainTabType(rawValue: tabBarController.selectedIndex) else {
            return
        }
        updateNavigationBar(with: tabType)
    }
    
}
