//
//  RxViewController.swift
//  RxController
//
//  Created by Meng Li on 04/09/2019.
//  Copyright (c) 2019 MuShare. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import RxSwift
import RxCocoa

protocol RxViewControllerProtocol {
    var view: UIView! { get }
    var rxViewModel: RxViewModel { get }
    
    func didMove(toParent parent: UIViewController?)
    func addChild(_ childVC: UIViewController)
    func addChild(_ childController: UIViewController, to containerView: UIView)
}

open class RxViewController<ViewModel: RxViewModel>: UIViewController, RxViewControllerProtocol {
    public let disposeBag = DisposeBag()
    public let mainScheduler = MainScheduler.instance
    public let viewModel: ViewModel
    
    var rxViewModel: RxViewModel {
        return viewModel
    }
    
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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controllerDidLoad()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.controllerDidAppear()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.controllerDidDisappear()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.controllerWillAppear()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.controllerWillDisappear()
    }

    /**
     Add a child view controller to the root view of this parent view controller.

     @param childController: a child view controller.
     */
    override open func addChild(_ childController: UIViewController) {
        super.addChild(childController)
        
        guard let childController = childController as? RxViewControllerProtocol else { return }
        viewModel.addChildModel(childController.rxViewModel)
        
        // Set the parent events property of the child view model.
        childController.rxViewModel._parentEvents = viewModel.events
        
        view.addSubview(childController.view)
        childController.didMove(toParent: self)
    }

    /**
     Add a child view controller to the root view of this parent view controller.

     @param containerView: a container view of childController.
     */
    open func addChild(_ childController: UIViewController, to containerView: UIView) {
        super.addChild(childController)
        guard let childController = childController as? RxViewControllerProtocol else { return }
        viewModel.addChildModel(childController.rxViewModel)

        // Set the parent events property of the child view model.
        childController.rxViewModel._parentEvents = viewModel.events

        // Add child view controller to the parent view controller.
        containerView.addSubview(childController.view)
        childController.didMove(toParent: self)

        childController.view.translatesAutoresizingMaskIntoConstraints = false
        childController.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        childController.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        childController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        childController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
}
