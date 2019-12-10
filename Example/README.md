# Example of RxController

The example app shows how to develop an iOS app with the MVVM-C design pattern using RxController(RxSwift, RxCocoa and RxFlow).
This documentation introduces the structure of this demo app, in order to helps you to understand RxController and use it in your project.

To extend `RxViewController` and `RxViewModel`, the subclass `BaseViewController` and `BaseViewModel` is prepared.

The app has the following tabs.
Each tab shows a scene with some components of RxController.

### Child View Controller Demo

This part shows how to use `BaseViewController` and `BaseViewModel` to create a standard view controller under the standard of RxController.

```
InfoViewController
├── NameViewController
│   ├── FirstNameViewController
│   ├── LastNameViewController
├── NumberViewController
```

In the root parent view controller `InfoViewController`, a random name including first and last name, a random telephone number,
and a update button are shown.
It has two child view controllers, `NameViewController` and `NumberViewController`.
The name and number in the child view controllers(`NameViewController` and `NumberViewController`) can be updated while the update button is clicked in the parent view controller `InfoViewController`,
because they can exchange data with events which are defined in the view model `InfoViewModel`.
Benefited by the events, when the update button in the childViewControllers is clicked, 
the corresponding label in the parent view controller can be updated.

As same as the system constituted by `InfoViewController`, `FirstNameViewController`, `LastNameViewController`,
the sub system constituted by `NameViewController`, `FirstNameViewController`, `LastNameViewController` have some events in the view model `NameViewModel`.
These events helps data changing among the view models of the sub system.

By default, events from `InfoViewModel` cannot be transported to `FirstNameViewModel` or `LastNameViewModel`.
Also, the events from `FirstNameViewModel` or `LastNameViewModel` cannot be transported to `InfoViewModel`.
The `forward` methods introduced in the event router can helps data changing from `InfoViewModel` to `FirstNameViewModel` via `NameViewModel`.

### Recursion Test

This tab shows how to create flows and jump to a new view controller or a new flow with `RxController` and `RxFlow`.
The following output of `rxtree` shows that `ProfileFlow` and `FriendsFlow` initialize each other recursively.

```
AppFlow
├── MainFlow
│   ├── ChildFlow
│   ├── ProfileFlow
│   │   ├── FriendsFlow
│   │   │   ├── ProfileFlow
│   │   │   │   ├── FriendsFlow
│   │   │   │   │   ├── ProfileFlow
│   │   │   │   │   │   ├── FriendsFlow
│   │   │   │   │   │   │   ├── ProfileFlow
│   │   │   │   │   │   │   │   ├── FriendsFlow
│   │   │   │   │   │   │   │   │   ├── ProfileFlow
│   │   │   │   │   │   │   │   │   ├── FriendsViewController
│   │   │   │   │   │   │   │   ├── ProfileViewController
│   │   │   │   │   │   │   ├── FriendsViewController
│   │   │   │   │   │   ├── ProfileViewController
│   │   │   │   │   ├── FriendsViewController
│   │   │   │   ├── ProfileViewController
│   │   │   ├── FriendsViewController
│   │   ├── ProfileViewController

```