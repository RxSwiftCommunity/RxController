# Chapter 4: View model

This chapter introduces the rule of view model.

## 4.1 Structure of view model

The structure of view models is flexible than view controllers.
The code in the view model should follow the order:

### Define the private properties

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

### Init method

```swift
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

## 4.2 Data transportation among view models
