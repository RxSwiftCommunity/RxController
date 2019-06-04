# RxController

[![CI Status](https://img.shields.io/travis/lm2343635/RxController.svg?style=flat)](https://travis-ci.org/lm2343635/RxController)
[![Version](https://img.shields.io/cocoapods/v/RxController.svg?style=flat)](https://cocoapods.org/pods/RxController)
[![License](https://img.shields.io/cocoapods/l/RxController.svg?style=flat)](https://cocoapods.org/pods/RxController)
[![Platform](https://img.shields.io/cocoapods/p/RxController.svg?style=flat)](https://cocoapods.org/pods/RxController)

RxController is a library for the development with MVVM-C based on **RxFlow** and **RxSwift**.
If you are not familiar with them, please learn these frameworks at first:

- RxSwift (https://github.com/ReactiveX/RxSwift)
- RxCocoa (https://github.com/ReactiveX/RxSwift)
- RxFlow (https://github.com/RxSwiftCommunity/RxFlow)

RxController provides the the following basic view controller and view model classes.

- RxViewController
- RxViewModel

These classes make it easy to transfer data among the flows, the parent view models and the child view models.

## Documentaion

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
// Add a child view controller to the root view of its parent controller.
func addChild<ViewModel: RxViewModel>(_ childController: RxViewController<ViewModel>, completion: ((UIView) -> Void)? = nil)

// add a child view controller to a customized view of its parent controller.
func addChild<ViewModel: RxViewModel>(_ childController: RxViewController<ViewModel>, to view: UIView, completion: ((UIView) -> Void)? = nil)
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

### Send a step to Flow from a child view model

In a general way, The method `steps.accpet()` of RxFlow cannot be revoked from a child view model, because we do not return the instances of the child view controller and child view model in the `navigate(to)` method of a flow.

To solve this problem, RxController provides a method `acceptStepsEvent` in the child view model, using the data transportation introduced above.

```Swift
acceptStepsEvent(DemoStep.stepname)
```

## Author

lm2343635, lm2343635@126.com

## License

RxController is available under the MIT license. See the LICENSE file for more info.
