# Chapter 2: Using RxFlow

This chapter introduces the basic usage of RxFlow in our guideline.

![Platform](https://raw.githubusercontent.com/lm2343635/RxController/master/images/rxflow.jpg)

In RxFlow, a step enum is a way to express a state that can lead to a navigation.
A flow class which holds the references of some view controllers and flows, defines a navigation area in your application.
**Each flow is corresponding to a step, the names of them are same.**

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