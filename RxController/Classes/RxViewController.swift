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
     Remove all child view controllers from this parent view controller,
     an except list can be specified.
     
     @param excepts: an except list
     */
    public func removeChildViewControllers(excepts: [UIViewController?] = []) {
        children.filter { !excepts.contains($0) }.forEach {
            $0.willMove(toParent: self)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    
    /**
     Add a child view controller to the root view of this parent view controller.
     
     @param childController: a child view controller.
     @param completion: a cloure which will be executed after adding the child view controller.
     */
    public func addChild<ViewModel: RxViewModel>(_ childController: RxViewController<ViewModel>, completion: ((UIView) -> Void)? = nil) {
        addChild(childController, to: view, completion: completion)
    }
    
    /**
     Add a child view controller to a customized view of this parent view controller.
     
     @param childController: a child view controller.
     @param view: a customzied view.
     @param completion: a cloure which will be executed after adding the child view controller.
     */
    public func addChild<ViewModel: RxViewModel>(_ childController: RxViewController<ViewModel>, to view: UIView, completion: ((UIView) -> Void)? = nil) {
        // Set the parent events property of the child view model.
        childController.viewModel._parentEvents = viewModel.events
        
        // Add child view controller to the parent view controller.
        addChild(childController)
        view.addSubview(childController.view)
        childController.didMove(toParent: self)
        
        completion?(childController.view)
    }
    
    /**
     Add a child view controller to the root view of this parent view controller,
     and make the size and center same as the root view.
     
     @param childController: a child view controller.
     */
    public func addFullSizeChild<ViewModel: RxViewModel>(_ childController: RxViewController<ViewModel>) {
        addFullSizeChild(childController, to: view)
    }
    
    /**
     Add a child view controller to a customized view of this parent view controller,
     and make the size and center same as the customized view.
     
     @param childController: a child view controller.
     @param view: a customzied view.
     */
    public func addFullSizeChild<ViewModel: RxViewModel>(_ childController: RxViewController<ViewModel>, to view: UIView) {
        addChild(childController, to: view) { [unowned view] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            $0.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            $0.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
    
}
