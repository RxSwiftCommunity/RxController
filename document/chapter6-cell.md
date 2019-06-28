# Chapter 6: Table and collection view cell

This chapter introduces the rule of table and collection view cell.
As same as the customized view, ** The MVC design pattern + Reactive extension is recommended to develop a cell. **

## 6.1 Structure of cell

We can easily understand a table or collection view cell as a special view.
Because a view controller does not hold the references of cells directly, the internal customized properties for data binding is not recommend in the code the cells.

## 6.2 Using RxDataSources and RxDataSourcesSingleSection

Native RxSwift library does not provide a easy way to manage complicated data source and animation.
With RxDataSources, we can easily define sections and data source.
RxDataSourcesSingleSection makes it easy to create a table view or a collection view with a single section.
RxDataSourcesSingleSection also define a `Configure` protocol which extends the `Reusable` protocol, to make the data binding of the cell more standardized.
Here, we introduce the rule of the cell based on RxDataSourcesSingleSection and its `Configure` protocol.

Each cell has its own view model, we call it view object of the cell to distinguish it from the view model concept in MVVM.
**The name of the view object is recommended to be same as the prefix of the cell, and `struct` is recommended to define a view object.**

```swift
class PersonTableViewCell: UITableViewCell {

}

struct Person {
    var name: String
    var address: Int
}
```

**The cell class should implement the `Configure` protocol.**
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