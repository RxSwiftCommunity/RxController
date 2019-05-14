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

    public func removeChildViewControllers(excepts: [UIViewController?] = []) {
        children.filter { !excepts.contains($0) }.forEach {
            $0.willMove(toParent: self)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    
    public func addChild<ViewModel: RxChildViewModel>(_ childController: RxChildViewController<ViewModel>, completion: ((UIView) -> Void)? = nil) {
        addChild(childController, to: view, completion: completion)
    }
    
    public func addChild<ViewModel: RxChildViewModel>(_ childController: RxChildViewController<ViewModel>, to view: UIView, completion: ((UIView) -> Void)? = nil) {
        // Set the parent events property of the child view model.
        childController.viewModel._parentEvents = viewModel.events
        
        // Add child view controller to the parent view controller.
        addChild(childController)
        view.addSubview(childController.view)
        childController.didMove(toParent: self)
        
        completion?(childController.view)
    }
  
}

