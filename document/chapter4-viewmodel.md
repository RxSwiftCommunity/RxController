# Chapter 4: View model

This chapter introduces the rule of view model.

## 4.1 Structure of view model

The structure of view models is flexible than view controllers.
The code in the view model should follow the order:

### Define the private store properties

Private properties contain both general type (`Int`, `String`, `Bool`, `User`), and RxSwift type (`BehaviourRelay`, `PublishSubject`) .
**The general type should be on the top of the RxSwift type.**

```swift
private let isVisable = true
private let userRealy = BehaviorRelay<User>(value: User())
```

**The name of RxSwift properties should containts a short suffix like `Relay` or `Subject`**

```swift
private let userRealy = BehaviorRelay<User>(value: User())
private let iconRealy = PublishRelay<UIImage?>()
private let userSubject = BehaviorSubject<User>()
private let iconSubject = PublishSubject<UIImage>(value: User())
```

### Define the child view model if needed

Define child view models here if needed with `private lazy var`.

```swift
private lazy var childViewModel = ChildViewModel()
```

### Deinit Init method

Append `deinit` and `init` methods here if needed.
**`deinit` method in recommended to be on the top of `init` method.**

```swift
deinit {
    // Do something here.
}

override init() {
    super.init()
    // Do something here.
}
```

### Override methods and properties.

```swift
override func prepareForParentEvents() {
    // Do something here.
}
```
### Private computed peroperties.

The type (`Int`, `String`, `Bool`, `User`) should be on the top of RxSwift type.

```swift
private var sex: Bool {
    return userRelay.value.sex
}

private var name: Observable<String?> {
    return userRelay.map { $0.name }
}
```

### Private methods.

```swift
private func setup() {

}
```

### Internal computed properties.

The type (`Int`, `String`, `Bool`, `User`) should be on the top of RxSwift type.

```swift
var sex: Bool {
    return userRelay.value.sex
}

var name: Observable<String?> {
    return userRelay.map { $0.name }
}
```

The computed observable properties is prepared for data binding in the `viewDidLoad` method of is view controller class.

**The name of computed observable propertie is the prefix of the subview's name.**

```swift
viewModel.name ~> nameLabel.rx.text
```

### Internal methods.

In a general way, the internal methods of view model are prepared for its view controller class.
Invoking the internal method in the flow or other view model is not recommended.
Exchanging data among view models with `steps` and `events` is recommended, this will be introduced in the chapter 4.2.

```swift
func pick(at index: Int) {
    // ...
}

func close() {
    steps.accept(UserStep.complete)
}

```

## 4.2 Exchange data among view models

We have 3 ways to exchange data among view models.

#### Using `steps` of RxFlow

A flow contains multiple view controllers.
**The view models of these view controllers should exchange data using `steps` of RxFlow.**

The type of the exchanging data is defined in the Step enum in the top of the Flow file.

```swift
enum UserStep {
    case start
    case user(User)
}
```

The step `user(User)` contains a parameter.
In the `UserListViewModel`, when the method `steps.accept(UserStep(user))` is invoked, the step will be executed.
We can get the parameter `user` and initialize `UserViewModel` with the `user` parameter.

```swift
case .user(let user):
    let userViewController = UserViewController(viewModel: .init(user: user))
    navigationController?.push(userViewController, animated: true)
    return .viewController(userViewController)
```

Of course, the init method with a user parameter should be prepared in `UserViewModel`.

```swift
class UserViewModel: BaseViewModel {

    init(user: User) {
        super.init()
        
        // Customized code.    
    }
    
}
```

Compared to using an internal method,
**the init method is recommended to pass the parameters to a new view model,**
because the init method can ensure passing the necessary parameters from grammatical level.

#### Using `events` of RxController

Exchanging data with `steps` among a view model and its child view models requires that the flow holds the references of the view models.
Many additional steps must be added with frequent data exchanging among child view models and the parent view model.
For these reasons, **`events` is recommended to change data among a view model and its child view models.**

**All events is recommended to be defined in the top of the common view model.**

```swift
struct InfoEvent {
    static let name = RxControllerEvent.identifier()
    static let number = RxControllerEvent.identifier()
}
```

A **common** view model depends on the structure of view controllers and the business logic.
It can be a parent view model or a child view model.

![Child view models](https://raw.githubusercontent.com/lm2343635/RxController/master/images/child_view_models.jpg)

In this graph, there are 6 view models, and the arrows represent the relationship among them.
There a 3 child view controller systems:

| Systems | Parent view Model | Child view models |
| ---- | ----- | ---- |
| A | VM 1 | VM 3 |
| B | VM 2 | VM 3, WM 4 |
| C | VM 4 | VM 5, WM 6 |

In the second and third systems (B and C), child view models have common parent view models.
Parent view models is common view models.
The events is recommended to be defined in the parent view model in such situations.

However, the parent view controller in the first and the second systems (A and B) has a some child view model.
Thus, the parent view models (VM 1 and VM2) may send some same objects to the child view model (VM 3).
In this situation, the child view model (VM 3) is regarded as the common view models, and the events should be defined in the child view model.

We have introduced the usage of `events` in the README of RxController. 
There are the ways to send and receive event in the parent view model and the child view models:

- Send a event from the parent view model (`InfoViewModel `).

```Swift
events.accept(InfoEvent.name.event("Alice"))
```

- Send a event from the child view model (`NameViewModel` and `NumberViewModel`).

```Swift
parentEvents.accept(event: InfoEvent.name.event("Alice"))
```

- Receive a event in the parent view model (`InfoViewModel `).

```Swift
var name: Observable<String?> {
    return events.value(of: InfoEvent.name)
}
```

- Receive a event in the child view model (`NameViewModel` and `NumberViewModel`).

```Swift
var name: Observable<String?> {
    return parentEvents.value(of: InfoEvent.name)
}
```

#### Using single instance manager class

If a same single instance needs to be shared among multiple view models, using a corresponding instance manager class is better than using `steps` and `events`.

```swift
class UserManager {
    static let shared = UserManager()
    
    private init() {}
    
    let user = UserRepository.shared.observeMySelf()
}
```

For most of the data exchanging,
**`steps` and `events` is recommended to used to exchange data among view models.**

## 4.3 Error Handling

Using the `bind(to:)` method cannot handle the error.
Without error handling in the view model, app will crash if an error comes.

**Observable objects for data binding in the view controller class cannot contain error event.**

```swift
private var userRelay = BehaviourRelay<User?>(value: nil)

override init() {
    super.init()
    
    UserManager.share.getMySelf()
        .bind(to: userRelay)
        .disposed(by: disposeBag)
}

var name: Observable<String?> {
    return userRelay.map {
        $0.name
    }
}

```

In this situation, if an error comes, the Observable cannot bind to the `userRelay` due to the error.
Of course, the name cannot be bind the the `nameLabel` in the view controller.

To solve this problem, we have 3 ways:

#### Subscribe the observable object

`onError` is ignored automatically after subscribing the observable object.

```swift
UserManager.share.getMySelf().subscribe(onNext: { [unowned self] in
    self.userRelay.accept($0)
}).disposed(by: disposeBag)
```

Of course, if the error should be handled in the view model, `onError` closure is needed.

#### Transform the observable object to a driver object

```swift
UserManager.share.getMySelf()
    .asDriver(onErrorJustReturn: nil)
    .drive(userRelay)
    .disposed(by: disposeBag)
```

Driver does not contains error event.
Ignore the error and provide a default value if a error event comes.

#### Handling error in your manager classes

The errors should be handled before using the method.