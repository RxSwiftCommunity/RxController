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
### Computed peropertis.

The computed observable properties is prepared for data binding in the `viewDidLoad` method of is view controller class.

```swift
var name: Observable<String?> {
    return user.map { user.name }
}
```

**The name of computed observable propertie is the prefix of the subview's name.**

```swift
viewModel.name ~> nameLabel.rx.text
```

### Methods.

Private methods and internal method should be written at last.

## 4.2 Data transportation among view models