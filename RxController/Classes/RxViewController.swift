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
    var rxViewModel: RxViewModel { get }
}

open class RxViewController<ViewModel: RxViewModel>: UIViewController, RxViewControllerProtocol {
    
    public let disposeBag = DisposeBag()
    public let mainScheduler = MainScheduler.instance
    public let viewModel: ViewModel
    
    var rxViewModel: RxViewModel {
        viewModel
    }
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in }
            .bind(to: viewModel.viewDidLoadSubject)
            .disposed(by: disposeBag)
        
        rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map { _ in }
            .bind(to: viewModel.viewWillAppearSubject)
            .disposed(by: disposeBag)
        
        rx.methodInvoked(#selector(viewDidAppear))
            .map { _ in }
            .bind(to: viewModel.viewDidAppearSubject)
            .disposed(by: disposeBag)
        
        rx.methodInvoked(#selector(viewWillDisappear(_:)))
            .map { _ in }
            .bind(to: viewModel.viewWillDisappearSubject)
            .disposed(by: disposeBag)
        
        rx.methodInvoked(#selector(viewDidDisappear(_:)))
            .map { _ in }
            .bind(to: viewModel.viewDidDisappearSubject)
            .disposed(by: disposeBag)
        
        rx.methodInvoked(#selector(viewWillLayoutSubviews))
            .map { _ in }
            .bind(to: viewModel.viewWillLayoutSubviewsSubject)
            .disposed(by: disposeBag)
        
        rx.methodInvoked(#selector(viewDidLayoutSubviews))
            .map { _ in }
            .bind(to: viewModel.viewDidLayoutSubviewsSubject)
            .disposed(by: disposeBag)
        
        if #available(iOS 11.0, *) {
            rx.methodInvoked(#selector(viewSafeAreaInsetsDidChange))
                .map { _ in }
                .bind(to: viewModel.viewSafeAreaInsetsDidChangeSubject)
                .disposed(by: disposeBag)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("RxController does not support to initialized from storyboard or xib!")
    }
    
    deinit {
        Log.debug("[DEINIT View Controller] \(type(of: self))")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        subviews().forEach { view.addSubview($0) }
        createConstraints()
        bind().forEach { $0.disposed(by: disposeBag) }
    }
    
    open func subviews() -> [UIView] {
        Log.debug("[WARNING] \(type(of: self)).subview() has not been overrided")
        return []
    }
    
    open func createConstraints() {
        Log.debug("[WARNING] \(type(of: self)).createConstraints() has not been overrided.")
    }
    
    open func bind() -> [Disposable] {
        Log.debug("[WARNING] \(type(of: self)).bind() has not been overrided.")
        return []
    }
    
    /**
     Add a child view controller to the root view of the parent view controller.
     @param childController: a child view controller.
     */
    override open func addChild(_ childController: UIViewController) {
        super.addChild(childController)
        
        view.addSubview(childController.view)
        childController.didMove(toParent: self)
        
        guard let childController = childController as? RxViewControllerProtocol else { return }
        viewModel.addChild(childController.rxViewModel)
    }
    
    /**
     Add a child view controller to the a container view of the parent view controller.
     The edges of the child view controller is same as the container view by default.
     
     @param childController: a child view controller.
     @param containerView: a container view of childController.
     */
    open func addChild(_ childController: UIViewController, to containerView: UIView) {
        super.addChild(childController)
        // Add child view controller to a container view of the parent view controller.
        containerView.addSubview(childController.view)
        childController.didMove(toParent: self)
        
        // Create constraints for the root view of the child view controller.
        childController.view.translatesAutoresizingMaskIntoConstraints = false
        childController.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        childController.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        childController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        childController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        guard let childController = childController as? RxViewControllerProtocol else { return }
        viewModel.addChild(childController.rxViewModel)
    }
    
}
