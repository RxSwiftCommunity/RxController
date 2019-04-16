//
//  RxViewController.swift
//  RxController
//
//  Created by Meng Li on 04/09/2019.
//  Copyright (c) 2019 MuShare. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class RxViewController<ViewModel: RxViewModel>: UIViewController {
    
    public let disposeBag = DisposeBag()
    public let mainScheduler = MainScheduler.instance
    public let viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log.debug("[DEINIT View Controller] \(type(of: self))")
    }

    public func removeChildViewControllers(excepts: [UIViewController?] = []) {
        children.filter { !excepts.contains($0) }.forEach {
            $0.willMove(toParent: self)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    
    public func addChild<ViewModel: RxChildViewModel>(_ childController: RxChildViewController<ViewModel>, completion: ((UIView) -> Void)? = nil) {
        addChild(childController)
        view.addSubview(childController.view)
        childController.didMove(toParent: self)
        completion?(childController.view)
    }
  
}

open class RxChildViewController<ViewModel: RxChildViewModel>: RxViewController<ViewModel> {
    
}
