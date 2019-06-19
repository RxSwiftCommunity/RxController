# Chapter 3: View controller and view model

This chapter introduces the rule of view controller and view model classes.

### 3.1 Using RxViewController

RxController provides a basic view controller `RxViewController` (generic classes) and a basic view model `RxViewModel`.

We recommend to create a BaseViewController which extends RxViewController and a BaseViewModel which extends RxViewController.
Developers can customized something in the BaseViewController and BaseViewModel class.

```swift
class BaseViewController<ViewModel: BaseViewModel>: RxViewController<ViewModel> {
    // Customize somthing here...
}

class BaseViewModel: RxViewModel {
    // Customize somthing here...
}
```

**All the view controller classes should extend the BaseViewController.**

**All the view model classes should extend the BaseViewModel**

### 3.2 Structure of view controller

The code in the view controller should follow the order:

#### Define views

**Views should be defined with `private lazy var`.**

```swift
private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(hex: 0x222222)
    label.font = UIFont.systemFont(ofSize: 14)
    return label
}()
```

**A closure should be used when some properties of this view need to be set.**
Otherwise, we omit the type and invoke the init method directly.

```swift
private lazy var nameLabel = UILabel()
```

**The order of the views should be same as the design.** 
The left views and top views should be in the top of the right views and the bottom views.

When we need a parent view a container view, **the container view should be defined after its subviews.**

```swift
private lazy var nameLabel = UILabel()

private lazy var iconImage = UIImageView()

private lazy var containerView: UILabel = {
    let view = UIView()
    view.addSubview(nameLabel)
    view.addSubview(iconImage)
    return view
}()
```

**The view definition closure does not contains the definition of subviews.** 
The following code is not recommended.

```swift
// NOT recommended.
private lazy var containerView: UILabel = {
    let view = UIView()
    let nameLabel = UILabel()
    view.addSubview(nameLabel)
    return view
}()
```

**The view definition closurecontains the properties and methods of this view only.**

### Define child view controllers

We define child view controllers using `private lazy var` after the definition of views.

```swift
private lazy var childViewController = ChildViewController(viewModel: init())
```

### Define data source of RxDataSources

We define the data source of RxDataSources using `private lazy var` after the definition of child view controllers.

```swift
private lazy var dataSource = DemoTableViewCell.tableViewSingleSectionDataSource()
```

### Define other private properties

Private properties are not recommended in the view controller.
The state properties are recommened to define in the view model class.
However, if needed, define them here.

### Init method

Set some properties of the view controller in `init` method if needed.

```swift
override init(viewModel: DemoViewModel) {
    super.init(viewModel: viewModel)
    
    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
```

Just invoke `fatalError` method in `required init?(coder aDecoder: NSCoder)` because we do not support storyboard.

### viewDidLoad method

The following steps should be contained in the `viewDidLoad` method.

- Set navigation bar and navigation items.
- Set peroperties of root view.
- Add subviews.
- Create constraints.
- Add child view controllers.
- Bind data.

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set navigation bar and navigation items.
    navigationItem.leftBarButtonItem = closeBarButtonItem
    
    // Set peroperties of root view.
    view.backgroundColor = .white
    // Add subviews.
    view.addSubview(titleLabel)
    view.addSubview(tableView)
    // Create constraints.
    createConstraints()
    
    //Add child view controllers.
    addChild(topViewController, to: headerView)
    
    // Bind data.
    disposeBag ~ [
        viewModel.title ~> titleLabel.rx.text,
        viewModel.cartSection ~> tableView.rx.items(dataSource: dataSource)
    ]
}
```

We use the operator `~>` and `<~>` of RxBinding to bind data.
**The order of the bind code should be same as the order of the definition of the views.**

### Other lifecycle methods.

Add other lifecycle methods here if needed.

### Create constraints method.

A contraints method contains the SnapKit constraint creators of all the views in this view controller.

**The constants used in the closure should be define in a private enum `Const` before the view controller**

```swift
private func createConstraints() {
    
    titleLabel.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalToSuperview().offset(Const.Title.marginTop)
    }
    
    closeButton.snp.makeConstraints {
        $0.centerY.equalTo(titleLabel.snp.centerY)
        $0.right.equalToSuperview().offset(-Const.Close.marginRight)
        $0.size.equalTo(Const.Close.size)
    }

}
```

**The sub enum in the `Const` enum is corresponding to the subview, and it name is the prefix of the subview's name.**

```swift
demoView -> enum Demo
demoLabel -> enum Demo
```

The demo code of `Const` enum:

```swift
private enum Const {
    
    enum Title {
        static let marginTop = 11
        static let marginBottom = 17
    }
    
    enum Close {
        static let size = 24
        static let marginRight = 11
    }
    
}
```

### 3.2 Structure of view model

The structure of view models is flexible than view controllers.
The code in the view model should follow the order:

### Define the private properties

```swift
private let user = BehaviorRelay<User>(value: User())
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