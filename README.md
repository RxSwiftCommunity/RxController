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
- RxChildViewController
- RxChildViewModel

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

RxController provides generic classes `RxViewController` and `RxChildViewController`.
With the genric classes, RxController avoids using an `Optional` or an `Implicit Unwrapping Option` type for the view model property in the view controller class.

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
With `RxChildViewModel` and `RxChildViewController`, we can exchange data among parent and child view models without the flow class.

Use the following method to add a child view controller to the root view or a customzied view of its parent controller.

```Swift
// Add a child view controller to the root view of its parent controller.
func addChild<ViewModel: RxChildViewModel>(_ childController: RxChildViewController<ViewModel>, completion: ((UIView) -> Void)? = nil)

// add a child view controller to a customzied view of its parent controller.
func addChild<ViewModel: RxChildViewModel>(_ childController: RxChildViewController<ViewModel>, to view: UIView, completion: ((UIView) -> Void)? = nil)
```

We define a event struct in the parent view model.

```Swift
struct InfoEvent {
    static let name = RxControllerEvent.identifier()
    static let number = RxControllerEvent.identifier()
}
```

Send a event from the parent view model.

```Swift
events.accept(InfoEvent.name.event("Alice"))
```

Send a event from the child view model.

```Swift
parentEvents.accept(event: InfoEvent.name.event("Alice")
```

Receive a event in the parent view model.

```Swift
var name: Observable<String?> {
    return events.value(of: InfoEvent.name)
}
```

Receive a event in the child view model.

```Swift
var name: Observable<String?> {
    return parentEvents.value(of: InfoEvent.name)
}
```

## Author

lm2343635, lm2343635@126.com

## License

RxController is available under the MIT license. See the LICENSE file for more info.
