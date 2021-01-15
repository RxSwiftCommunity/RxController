//
//  RxControllerEventRouter.swift
//  RxController
//
//  Created by Meng Li on 08/06/2019.
//  Copyright © 2019 MuShare. All rights reserved.
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

import RxCocoa
import RxSwift

public protocol RxControllerEventRouter: class {
    var events: PublishRelay<RxControllerEvent> { get }
    var parentEvents: PublishRelay<RxControllerEvent> { get }
    var disposeBag: DisposeBag { get }
}

struct RxControllerEventForwarder {
    let input: PublishRelay<RxControllerEvent>
    let inputIdentifier: RxControllerEvent.Identifier
    let output: PublishRelay<RxControllerEvent>
    let outputIdentifier: RxControllerEvent.Identifier

    func forward() -> Disposable {
        return input.value(of: inputIdentifier).subscribe(onNext: {
            self.output.accept(self.outputIdentifier.event($0))
        })
    }

    func forward<T, O: ObservableConvertibleType>(flatMapLatest: @escaping ((T?) -> O)) -> Disposable {
        return input.value(of: inputIdentifier, type: T.self)
            .flatMapLatest(flatMapLatest)
            .subscribe(onNext: {
                self.output.accept(self.outputIdentifier.event($0))
            })
    }
}

extension RxControllerEventRouter {

    public func forward(
        parentEvent parentEventIdentifier: RxControllerEvent.Identifier,
        toEvent eventIdentifier: RxControllerEvent.Identifier
    ) {
        let forwarder = RxControllerEventForwarder(
            input: parentEvents, inputIdentifier: parentEventIdentifier,
            output: events, outputIdentifier: eventIdentifier
        )
        return forwarder.forward().disposed(by: disposeBag)
    }

    public func forward<T, O: ObservableConvertibleType>(
        parentEvent parentEventIdentifier: RxControllerEvent.Identifier,
        toEvent eventIdentifier: RxControllerEvent.Identifier,
        flatMapLatest: @escaping (T?) -> O
    ) {
        let forwarder = RxControllerEventForwarder(
            input: parentEvents, inputIdentifier: parentEventIdentifier,
            output: events, outputIdentifier: eventIdentifier
        )
        forwarder.forward(flatMapLatest: flatMapLatest).disposed(by: disposeBag)
    }

    public func forward(
        event eventIdentifier: RxControllerEvent.Identifier,
        toParentEvent parentEventIdentifier: RxControllerEvent.Identifier
    ) {
        let forwarder = RxControllerEventForwarder(
            input: events, inputIdentifier: eventIdentifier,
            output: parentEvents, outputIdentifier: parentEventIdentifier
        )
        forwarder.forward().disposed(by: disposeBag)
    }

    public func forward<T, O: ObservableConvertibleType>(
        event eventIdentifier: RxControllerEvent.Identifier,
        toParentEvent parentEventIdentifier: RxControllerEvent.Identifier,
        flatMapLatest: @escaping (T?) -> O
    ) {
        let forwarder = RxControllerEventForwarder(
            input: events, inputIdentifier: eventIdentifier,
            output: parentEvents, outputIdentifier: parentEventIdentifier
        )
        forwarder.forward(flatMapLatest: flatMapLatest).disposed(by: disposeBag)
    }

}
