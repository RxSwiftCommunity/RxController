# Chapter 5: View

This chapter introduces the rule of view including system views of UIKit and customized views.

** The MVC design pattern + Reactive extension is recommended to develop a customized view. **
We don't recommend to use RxSwift and MVVM directly in a customized view, because managing the `disposeBag` in the view may cause some memory leak issues.

If the customized view is simple and only used in a single view controller, it is recommended to be written as a `private class` at the last of the view controller.
Otherwise, creating a file for the customized view and implement with a `internal class` is recommended.

## 4.1 Structure of a customized view model

We have introduced the difference between the view controller and the customized view model.
We can simply understand the customized view model as a simple view controller without view model.

The code in the customized view model should follow the order:

### Define views

The rule of the view definition is same as view controller.

```swift
private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(hex: 0x222222)
    label.font = UIFont.systemFont(ofSize: 14)
    return label
}()
```

Internal subviews is not recommended in the customzied view.
Internal methods and propertied is recommended as the wrapper of the methods and properties of the private subviews.

### Define other private properties

Private properties stores the state of views.

```swift
private var isButtonEnable = false
```

### Init method

Without lifecycle like view controller, we can add subviews to the view and create constraints directly in the `init` method.

```swift
class InfoView: UIView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        createConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```

### Override methods and properties.

Override other methods and properties here.
Override methods is on the top of override properties.

```swift
override func configure(model: Model) {
    nameLabel.text = model.name
}
    
override var isHighlighted: Bool {
    didSet {
        if isHighlighted {
            backgroundView?.backgroundColor = UIColor(hex: 0xdddddd)
        } else {
            backgroundView?.backgroundColor = .white
        }
    }
}
```

### Create constraints method.

The rule of the `createcConstraints` method is same as view controller.

### Other methods.

The private methods should be on the top of the internal methods.

```swift
private func a() {

}

func b() {

}
```

### Computed properties.

The private computed properties should be on the top of the internal computed properties.
The computed properties with only get method should be on the top of the properties with both set and get methods.
**Definition of computed properties should follow the orders:**

- Private computed properties
    - Private computed properties with only get method
    - Private computed properties with both set and get methods
- Internal computed properties
    - Internal computed properties with only get method
    - Internal computed properties with both set and get methods

```swift
private var name: String? {
    return nameLabel.text
}

private var icon: UIImage? {
    set {
        iconImageView.image = newValue
    }
    get {
        return iconImageView.image
    }
}

var title: String? {
    return titleLabel.text
}

var avatar: UIImage? {
    set {
        avararImageView.image = newValue
    }
    get {
        return avararImageView.image
    }
}

```

**The set method should be on the top of get method.**

We have introduced that internal subviews is not recommended in the customzied view.
The internal computed properties with both set and get methods is recommended to be used as a wrapper of the properties of subviews.

### Store properties with method

The private store properties should be on the top of the internal store properties.
The store properties is used for saving state of views or the data model.

```swift
var user: User? {
    didSet {
        guard let user = user else {
            return
        }
        nameLabel.text = user.name
        avatarImageView.image = user.avatar
    }
}
```

## 4.2 Code in the closure to initialize a view

We initialize subviews in a view controller or a customized view with closure if some properties need to be set.
**The code in the closure should follow the orders.**

- Part 1: Set properties
    - Set properties of this view.
    - Set properties of its subviews, although setting properties of subviews is not recommended.
    - Set properties of its sublayers
- Part 2: Methods of this view.
- Part 3: Add subviews or sublayers
    - Add subviews.
    - Add sublayers.
- Part 4: RxSwift related code.
    - Subscribe.
    
```swift
private lazy var closeButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .clear
    button.setImage(R.image.close(), for: .normal)
    button.addsubView(blurView)
    button.rx.tap.bind { [unowned self] in
        self.viewModel.close()
    }.disposed(by: disposeBag)
    return button
}()
```

## 4.3 Reactive extension for view

Invoking the internal methods and properties in the view controller directly is not recommended in our guideline.
Because developing with MVVM based on RxSwift, all data should be transferred with the `Observable` object of RxSwift.
For example, there is a property `name` in a customized view `NameView`.

```swift
class NameView: UIView {

    // ...
    
    var name: String? {
        set {
            nameLabel.text = newValue
        }
        get {
            return nameLabel.text
        }
    }
}
``` 

We define an `Observable` object `name` in the view model class.

```swift
var name: Observable<String?> {
    return user.map { $0.name }
}
```

We hope to bind `name` to the `nameView` directly rather than subscribing `name` and setting it in the `onNext` closure.

```swift
viewModel.name ~> nameView.rx.name
```

Here, like the reactive extension in the view controller,
**reactive extension is recommended to bind data for a customized view.**
For this purpose, it better to create a binder in the reactive extension .

```swift
extension Reactive where Base: NameView {

    var name: Binder<String?> { view, name in 
        view.name = name
    }
    
}
```

Compared to the data binding in the view controller, 
the customized view provides both internal/public properties or methods and reactive extension binder to update UI,
while the view controller provides the reactive extension binder only.