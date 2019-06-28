<p align="center">
<img src="https://raw.githubusercontent.com/lm2343635/RxController/master/images/logo.jpg" alt="RxController" title="RxController" width="600"/>
</p>

<p align="center">
<a href="https://app.bitrise.io/app/60e541fa833b19d2"><img src="https://app.bitrise.io/app/60e541fa833b19d2/status.svg?token=FWKV3OHJ-W0F2AtZP4M1bw&branch=master"></a>
<a href="https://https://cocoapods.org/pods/RxController"><img src="https://img.shields.io/cocoapods/v/RxController.svg?style=flat"></a>
<a href="https://https://cocoapods.org/pods/RxController"><img src="https://img.shields.io/cocoapods/l/RxController.svg?style=flat"></a>
<a href="https://https://cocoapods.org/pods/RxController"><img src="https://img.shields.io/cocoapods/p/RxController.svg?style=flat"></a>
</p>

## Introduction.

RxController is a library for the development with MVVM-C based on **RxFlow** and **RxSwift**.
If you are not familiar with them, please learn these frameworks at first:

- RxSwift (https://github.com/ReactiveX/RxSwift)
- RxCocoa (https://github.com/ReactiveX/RxSwift)
- RxFlow (https://github.com/RxSwiftCommunity/RxFlow)

RxController provides the the following basic view controller and view model classes.

- RxViewController
- RxViewModel

These classes make it easy to transfer data among the flows, the parent view models and the child view models.

## Recommended guideline

We recommended to develop a MMVM-C based on **RxController**, **RxFlow** and **RxSwift** with this guideline.
It better to read the documentation of [RxController](https://github.com/xflagstudio/RxController), [RxFlow](https://github.com/RxSwiftCommunity/RxFlow) and [RxSwift](https://github.com/ReactiveX/RxSwift) at first, if you are not familiar with them.

- Chapter 1: [Introduction](https://github.com/xflagstudio/RxController/blob/master/document/chapter1-introduction.md)
- Chapter 2: [Using RxFlow](https://github.com/xflagstudio/RxController/blob/master/document/chapter2-rxflow.md)
- Chapter 3: [View controller](https://github.com/xflagstudio/RxController/blob/master/document/chapter3-viewcontroller.md)
- Chapter 4: [View model](https://github.com/xflagstudio/RxController/blob/master/document/chapter4-viewmodel.md)
- Chapter 5: [View](https://github.com/xflagstudio/RxController/blob/master/document/chapter5-view.md)
- Chapter 6: [Table and collection view cell](https://github.com/xflagstudio/RxController/blob/master/document/chapter6-cell.md)

## Documentation

RxController is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RxController'
```

### Example

The example app helps you to understand how to use RxController.
To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Generic class of View Controller

RxController provides a generic classes `RxViewController`.
It avoids using an `Optional` or an `Implicit Unwrapping Option` type for the view model property in the view controller class.

In the demo app, we define the view model class by extending the RxViewModel class, and the view controller class by extending the RxViewController generic class.

```Swift
// View model class
class InfoViewModel: RxViewModel {

}

// View controller class
class InfoViewController: RxViewController<InfoViewModel> {

}
```

Then, we can initialize the `InfoViewController` with a safe way as the following.

```Swift 
func navigate(to step: Step) -> FlowContributors {
    guard let appStep = step as? AppStep else {
        return .none
    }
    switch appStep {
    case .start:
        let infoViewController = InfoViewController(viewModel: InfoViewModel())
        navigationController.pushViewController(infoViewController, animated: false)
        return .viewController(infoViewController)
    }
}
```

### Data Transportion among parent and child view models

In a standard MVVM-C architecture using RxFlow, view models exchange data via the a flow class using the `steps.accept()` method.
With `RxChildViewModel`, we can exchange data among parent and child view models without the flow class.

Use the following method to add a child view controller to the root view or a customized view of its parent controller.

```Swift
/**
 Add a child view controller to the root view of the parent view controller.

 @param childController: a child view controller.
 */
override open func addChild(_ childController: UIViewController)

/**
 Add a child view controller to the a container view of the parent view controller.
 The edges of the child view controller is same as the container view by default.
 
 @param childController: a child view controller.
 @param containerView: a container view of childController.
 */
open func addChild(_ childController: UIViewController, to containerView: UIView)
```

To transfer data among view models, we define some events with a struct in the parent view model.

```Swift
struct InfoEvent {
    static let name = RxControllerEvent.identifier()
    static let number = RxControllerEvent.identifier()
}
```

![Platform](https://raw.githubusercontent.com/lm2343635/RxController/master/images/viewmodel.jpg)

As shown in the graph, the events can only be transfered among a parent view model and its first generation child view models.
For example, the `InfoEvent` we defined above, is enabled among `InfoViewModel`, `NameViewModel` and `NumberViewModel`.

Send a event from the parent view model (`InfoViewModel `).

```Swift
events.accept(InfoEvent.name.event("Alice"))
```

Send a event from the child view model (`NameViewModel` and `NumberViewModel`).

```Swift
parentEvents.accept(event: InfoEvent.name.event("Alice")
```

Receive a event in the parent view model (`InfoViewModel `).

```Swift
var name: Observable<String?> {
    return events.value(of: InfoEvent.name)
}
```

Receive a event in the child view model (`NameViewModel` and `NumberViewModel`).

```Swift
var name: Observable<String?> {
    return parentEvents.value(of: InfoEvent.name)
}
```

Pay attention to that **subscribing the `RxControllerEvent` in the `init` method of the view model is not effective**.
It necessary to subscribe the `RxControllerEvent` in the `prepareForParentEvents` methods like:

```Swift
override func prepareForParentEvents() {
    parentEvents.unwrappedValue(of: Event.sample, type: EventData.self)
    	.bind(to: data).disposed(by: disposeBag)
}
```

### Send a step to the flow from a child view model

In a general way, the method `steps.accpet()` of RxFlow cannot be revoked from a child view model, because we didn't return the instances of the child view controller and child view model in the `navigate(to)` method of a flow.

With RxController, it is able to send a step to the flow from a child view model directly.

```Swift
steps.accept(DemoStep.stepname)
```

## Author

lm2343635, lm2343635@126.com

## License

RxController is available under the MIT license. See the LICENSE file for more info.
