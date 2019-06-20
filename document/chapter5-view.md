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

### Store properties

The private store properties should be on the top of the internal store properties.

## 4.2 Set properties in the closure

We initialize subviews in a view controller or a customized view with closure if some properties need to be set.
**Setting properties in the closure should follow the orders.**
