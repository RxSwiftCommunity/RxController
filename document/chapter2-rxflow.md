# Chapter 2: Using RxFlow

This chapter introduces the basic usage of RxFlow in our guideline.

![RxFlow](https://raw.githubusercontent.com/lm2343635/RxController/master/images/rxflow.jpg)

In RxFlow, a step enum is a way to express a state that can lead to a navigation.
A flow class which holds the references of some view controllers and flows, defines a navigation area in your application.
**Each flow is corresponding to a step, the names of them are same.**

## 2.1 Start app with RxFlow

An `AppFlow`, which is corresponding to `AppStep` is recommended as a start flow in our guideline.

```swift
import UIKit
import RxFlow

enum AppStep: Step {
    case start
}

class AppFlow: Flow {
    
    var root: Presentable {
        return rootWindow
    }
    
    private let rootWindow: UIWindow
    
    private lazy var navigationController = UINavigationController()
    
    init(window: UIWindow) {
        rootWindow = window
        rootWindow.rootViewController = navigationController
    }
   
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
    
}

```

Then we navigate to the `AppFlow` in the AppDelegate class.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    coordinator.rx.didNavigate.subscribe(onNext: {
        print("did navigate to \($0) -> \($1)")
    }).disposed(by: disposeBag)
    
    coordinate {
        (AppFlow(window: $0), AppStep.start)
    }
    return true
}

private func coordinate(to: (UIWindow) -> (Flow, Step)) {
    let (flow, step) = to(window)
    coordinator.coordinate(flow: flow, with: OneStepper(withSingleStep: step))
    window.makeKeyAndVisible()
}
```

## 2.2　Screen transition

RxFlow controls screen transition among view controllers.
A step enum defines a navigation area, each step defines a transition between two view controllers.

For example, a `SigninFlow` contains a `SignViewController` ans `SignupViewController`.
It containts the following 3 steps:
- `start`: When this flow is loaded, the `SignViewController` will be shown.
- `signup`: When the `Sign Up` button in the `SignViewController` is clicked, the `SignupViewController` will be presented with a modal.
- `signupIsComplete`: If user submit the form in the `SignupViewController`, the `SignupViewController` will be dismissed.

```swift
enum SigninStep {
    case start
    case signup
    case signupIsComplete
}
```

As same as `AppFlow`, we return `signinViewController` for `root`, and implement `navigate(to step:)` method.
**In a step, returning with `.viewController(vc)` is required for navigating to a new view controller.**
Otherwise, the `steps` relay cannot be used in the view model of this new view controller.
In this example, we return with `.viewController(vc)` in the `.start` step and `.signinStep`.

```swift
class SigninFlow: Flow {
    
    var root: Presentable {
        return signinViewController
    }
    
    private lazy var signinViewController = SigninViewController()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let sininStep = step as? SigninStep else {
            return .none
        }
        switch sininStep {
        case .start:
            return .viewController(signinViewController)
        case .signup:
            let signupViewController = SignupViewController(viewModel: .init())
            signinViewController.present(signupViewController, animated: true)
            return .viewController(signupViewController)
        case .signupIsComplete:
            guard let signupViewController = signinViewController.presentedViewController as? SignupViewController else {
                return .none             
            }
            signupViewController.dismiss(animated: true)
            return .none   
        }
    }
    
}
```

Using a step for multiple screen transitions is difficult to manage.
For this reason, **One-To-One relationship bwtween a step and a screen transition is recommended.**

To back to the `SigninViewController` from `SignupViewController`, we invoke `steps.accept(SigninStep.signupIsComplete)` in the view model of `SignupViewController`.

```swift
func signup() {
    // Sign up related code here...
    
    // Back to signin
    steps.accept(SigninStep.signupIsComplete)
}
```

**All screen transitions should be managed in the flows.**

## 2.3 Present navigation controller in a step

If a navigation controller is presented in a step, you should pay attention to the memory leak issue.
A navigation controller has a root view controller named `rootViewController` which is a subclass of RxController.
**DO NOT** return `.viewController(rootViewController)` directly in this step.
Because he navigation controller is not managed by the RxFlow, a memory leak issue will be caused when this flow is ended.

**Return `.navigationController(navigationController)` in the step, if a navigation controller with a root view controller, which is a subclass of RxController, is presented.**

```swift
case .childOnNavigation:
    guard let menuViewController = navigationController.topViewController as? MenuViewController else {
        return .none
    }
    let infoViewController = InfoViewController(viewModel: InfoViewModel())
    let navigationController = UINavigationController(rootViewController: infoViewController)
    menuViewController.present(navigationController, animated: true)
    return .navigationController(navigationController)
```
