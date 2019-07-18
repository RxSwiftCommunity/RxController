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

#### Omit if possible

- Omit `self` keyword if possible

```swift
viewModel.title ~> titleLabel.rx.text
```

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