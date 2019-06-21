# Chapter 5: View

## 4.1 Structure of a customized view model

We have introduced the difference between the view controller and the customized view model.
We can simply understand the customized view model as a simple view controller without view model.
The code in the customized view model should follow the order:

### Define views

The rule of the view definition is same as view controller.

### Define other private properties
### Init method
### Override methods and properties.
### Create constraints method.

The rule of the `createcConstraints` method is same as view controller.

### Other methods.

The private methods should be on the top of the internal methods.

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