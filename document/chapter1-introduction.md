# Chapter 1: Introduction

This guideline introduces how to develop a MVVM-C app based the RxController library.
We will call MVVM directly in this guideline, it represents MVVM-C design pattern.
The content in this guideline is just suggestions for developing a MVVM-C app.

### 1.1 Purpose

RxSwift and RxFlow help developers to develop an app with MVVM.
However, they do not provide a standard coding rule.
The code style, especially the code of exchanging data among view models and controller presentation, will become very flexible.
This guideline proposes a standard code style using RxController for teamwork development.

This guideline follows the 3 principles:

- **Standardization** : All of the code should follow a standard code style.
- **Readability** : The pull request should be easy to read and understand.
- **Modularization** : Module development is recommended, and the API of the module should be simple and easy to read.

The readability is based on the enough understanding of [RxController](https://github.com/xflagstudio/RxController), [RxFlow](https://github.com/RxSwiftCommunity/RxFlow) and [RxSwift](https://github.com/ReactiveX/RxSwift).
For module development, the simple API is required, while the code in the module is not required to follow the principles.

### 1.2 Libraries

This MVVM design pattern of this guideline depends on the following libraries:

- RxSwift (https://github.com/ReactiveX/RxSwift)
- RxCocoa (https://github.com/ReactiveX/RxSwift)
- RxFlow (https://github.com/RxSwiftCommunity/RxFlow)
- RxController (this repo)

RxSwift and RxCocoa are basic FRP libraries.
RxFlow is a coordinator library.
This library, RxController, provides some wrapper methods for RxFlow, the basic view controller and view model classes, and event based data exchanging among view models.

The following libraries helps us to develop with MVVM easily.

- SnapKit (https://github.com/SnapKit/SnapKit):
Using storyboard requires to load view controller from storyboard, that is not convenient to manage the references of view controllers in the flow class.
For this reason, we recommend to use SnapKit to create UI manually rather than using Storyboard.

- RxDataSources (https://github.com/RxSwiftCommunity/RxDataSources)
- RxDataSourcesSingleSection (https://github.com/xflagstudio/RxDataSourcesSingleSection)
RxDataSources provides advanced table and collection view data sources.
It makes the development of animated table and collection collection easy, because it contains algorithm for calculating differences.
However, it requires to build a data source with multiple sections for table and collection view.
Mostly, we don't need multiple sections in our apps.
To simplify the code for the single section data source, we use the RxDataSourcesSingleSection library.

- RxBinding (https://github.com/RxSwiftCommunity/RxBinding)
RxBinding provides `~>`, `<~>` and `~` operators for data binding using RxSwift, to replace the `bind(to:)` and `disposed(by:)` method in RxSwift.

**The operators of RxBinding is recommended to be used in data binding for the view model only.**

```swift
viewModel.name ~> nameLabel.rx.text
```

### 1.3 Code Style

#### Indent

- Continuous methods invoking

Sometimes, methods are invoked continuously like `users.filter().map().reduce()`.
If thees methods and thier closures are too long, line feed is needed.
When a new line is started, we should pay attention to the indent.

If the last line is ended with an uncompleted clousre like `user.map {`, the new line should not be started with indent.
In addition, the indent of the line with the end brace `{` of this closure should be same with the line with the start brace `{`.

```swift
user.filter { $0.id != userId }.map {
    UserItem(user: user)
}
```

If the last line is ended without an uncompleted closure, a property or a method, the new line should be started with indent.

```swift
user.filter { $0.id != userId }
    .map { UserItem(user: user) }
```

#### Line feed

A line which contains more than 127 characters cannot be shown completely in the Github code viewer.
Depends on you browser, the number of the visible characters may be different.

When a line contains more than 127 characters, we can divided it into multiple line.
A new line is recommended when a method is invoked or a closure content is started.

```swift
var name: Observable<String?> {
    user.map { $0.name }.distinctUntilChanged().take(1).map {
        R.string.localizable.user_profile_full_name($0)
    }
}
```

However, for the continuous semantic structure like `user_profile_full_name($0)`, a new line is not recommended although its line contains more than 127 characters.

#### Omit if possible

- Omit `return` for computed property.

```swift
var name: Binder<String?> {
    Binder(base) { view, name in 
        view.name = name
    }
}
```

Even it is able to omit `return` for a method with a single line, such a style is not recommended, because it makes harder to distingush a method that returns a value and which does not returns a value.

- Omit `import Foundation` and `import UIKit`

In the Swift project, `import Foundation` and `import UIKit` is not necessary.
To simplify the code, they are not recommended to be imported.

- Omit `self` keyword if possible

```swift
viewModel.title ~> titleLabel.rx.text
```

For some situations, the `self` keyword cannot be omitted.
For example, when the properties are used with in a clousre, the `self` property should be captured with `[unowned self]` or `[weak self]` to avoid memoery leak.
If there are too many `self` keywoard within our code, it is difficult for us to concentrate on those situations we need pay attention to.
For this reason, unnecessary `self` keywords are recommended to be omitted.

- Omit `class`, `struct` and `enum` keyword if possible.

```swift
label.lineBreakMode = .byWordWrapping
```

- Omit decimal point if possible

```swift
label.font = .boldSystemFont(ofSize: 48)
```

- Omit the closure name of a method, if the only one closure parameter of this method is used.

```swift
UIView.animate(withDuration: 1) { 
    // Do something ...
}
```

**If multiple closure parameters are used, all of the closure names should be written.**

```swift
UIView.animate(withDuration: 1, animations: { 
    // Do something ...
}, completion: {
    // Do something ...
})
```

- Omit the parameter name of a closure, if the closure contains only one parameter.

```swift
tableView.rx.itemSelected.bind { [unowned self] in
    self.viewModel.pick(at: $0.row)
}.disposed(by: disposeBag)
```

Omit multiple parameter names of a clousre is not recommended.
