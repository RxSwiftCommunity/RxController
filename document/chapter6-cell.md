# Chapter 6: Table and collection view cell

This chapter introduces the rule of table and collection view cell.
As unlike the view controller and customized view, **The pure MVC design pattern is recommended to develop a cell.**

## 6.1 Structure of cell

We can easily understand a table or collection view cell as a special view.
Generally, a cell contains the following parts:

### Same parts as customzied view

- [Define views](https://github.com/xflagstudio/RxController/blob/master/document/chapter5-view.md#define-views)
- [Define other private properties](https://github.com/xflagstudio/RxController/blob/master/document/chapter5-view.md#define-other-private-properties)
- [Init method](https://github.com/xflagstudio/RxController/blob/master/document/chapter5-view.md#init-method)
- [Override methods and properties](https://github.com/xflagstudio/RxController/blob/master/document/chapter5-view.md#override-methods-and-properties)
- [Create constraints method](https://github.com/xflagstudio/RxController/blob/master/document/chapter5-view.md#create-constraints-method)

### Private methods and computed properties

Because a view controller does not hold the references of cells directly, the internal customized properties for data binding is not recommend in the code the cells.

```swift
private var name: String? {
    return nameLabel.text
}

private func updateName() {
    
}

```

### Define model and implement `Configurable` protocol

This will be introduced in the next part [Using RxDataSources and RxDataSourcesSingleSection](https://github.com/xflagstudio/RxController/blob/master/document/chapter6-cell.md#62-using-rxdatasources-and-rxdatasourcessinglesection)

## 6.2 Using RxDataSources and RxDataSourcesSingleSection

Native RxSwift library does not provide a easy way to manage complicated data source and animation.
With RxDataSources, we can easily define sections and data source.
RxDataSourcesSingleSection makes it easy to create a table view or a collection view with a single section.
RxDataSourcesSingleSection also define a `Configurable` protocol which extends the `Reusable` protocol, to make the data binding of the cell more standardized.
Here, we introduce the rule of the cell based on RxDataSourcesSingleSection and its `Configurable` protocol.

Each cell has its own view model, we call it view object of the cell to distinguish it from the view model concept in MVVM.
**The name of the view object is recommended to be same as the prefix of the cell. To prevent the memory leak issues, `struct` is recommended to define a view object rather than `class`.**

```swift
class PersonTableViewCell: UITableViewCell {

}

struct Person {
    var name: String
    var address: Int
}
```

**The cell class should implement the `Configurable` protocol.**
The `Model` of the `associatedtype` is view object.
In the `configure` method, we bind data to the views with the view object.

```swift
extension PersonTableViewCell: Configurable {

    typealias Model = Person

    func configure(_ model: Person) {
        nameLabel.text = model.name
        addressLabel.text = model.address
    }

}
```

## 6.3 Table view cell height

Calculating cell height is a troublesome problem for the table view cell.
If the cell height is dynamical, using autolayout using SnapKit in the cell and automatic row height in the table view is recommended.

```swift
private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.register(cellType: DemoTableViewCell.self)
    return tableView
}()
```

In the cell class, the autolayout rule is different with which in the view controller or the customized view.

## 6.4 Tap action

We can handle the tap action for a cell with the `didItemSelect` delegate method of `UITableViewDelegate` or `UICollectionViewDelegate`,
or using some customized buttons.

### Using system defined delegate methods.

Using a delegate method with an extension in the view controller is not recommended.
RxCocoa provides reactive extension for most of the delegate methods.
**Handling the delegate methods with reactive extension in the definition closure of a table view or a collection view is recommended.**

```swift
private lazy var tableView: UITableView = {
    let tableView = UITableView()
    // Set the table view...
    tableView.rx.itemDidSelected.bind { [unowned self] in 
        // Invoke a method in the view model.
        self.viewModel.pick(at: $0.row)
    }.disposed(by: disposeBag)
    return tableView
}()
```

An internal method in corresponding view model should be prepared.

```swift
func pick(at index: Int) {
    // Do something here...
}
```

### Customized buttons

Sometimes, a single cell may contains multiple tap action for multiple customized buttons.
In the view controller, the reactive extension is recommended in the definition closure of the customized buttons.
However, for the reusable cells, managing the `disposeBag` and avoiding the multiple tap action binding are troublesome.
As we said in the top of this chapter, **the pure MVC design pattern is recommended for handling events of reusable cells.**
Here, we define the customized button and add tap action with `addTarget` method directly.

```swift
private lazy var favoriteButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .white
    button.nameColor = .black
    button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    return button
}()
```

When the button is tapped, the objc method will be invoked.

```swift
@objc
private func favoriteTapped() {
    didFavoriteTapped?()
} 
```
In this private method, an optional closure is invoked.
This clousre is defined as an internal optional property.

```swift
var didFavoriteTapped: (() -> Void)?
```

The tapped closure should be setted in the dataSource of the tableView.

```swift
private lazy var dataSource = FavoriteTableViewCell.tableViewSingleSectionDataSource(configureCell: { [unowned self] cell, indexPath, _ in
    cell.didFavoriteTapped = { 
        self.viewModel.pick(at: indexPath.row)
    }
})
```

At last, a method in the view model will be invoked.
This method is responsible for handling the specific business logic.
