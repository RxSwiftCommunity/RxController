# Chatper 1: Indroduction

This guideline introduces how to develop a MVVM-C app based the RxController library.
We will call MVVM directly in this guideline, it represents MVVM-C design pattern.
The content in this guideline is just suggestions for developing a MVVM-C app.

### 1.1 Purpose

RxSwift and RxFlow help developers to develop an app with MVVM.
However, they do not provide a standard coding rule.
The code style, especially the code of data transportation and controller presentation, will become very flexible.
This guideline proposes a standard code style using RxController for teamwork development.

### 1.2 Libraries

This MVVM design pattern of this guideline depends on the following libraries:

- RxSwift (https://github.com/ReactiveX/RxSwift)
- RxCocoa (https://github.com/ReactiveX/RxSwift)
- RxFlow (https://github.com/RxSwiftCommunity/RxFlow)
- RxController (this repo)

RxSwift and RxCocoa are basic FRP libraries.
RxFlow is a coordinator library.
This library, RxController, provides some wrapper methods for RxFlow, the basic view controller and view model classes, and event based data transportation among view models.

The following libraries helps us to develop with MVVM easily.

- SnapKit (https://github.com/SnapKit/SnapKit):
Using storyboard requires to load view controller from storyboard, that is not convenient to manage the references of view controllers in the flow class.
For this reason, we recommend to use SnapKit to create UI manually rather than using Storyboard.

- RxDataSources (https://github.com/RxSwiftCommunity/RxDataSources)
- RxDataSourcesSingleSection (https://github.com/lm2343635/RxDataSourcesSingleSection)
RxDataSources provides advanced table and collection view data sources.
It makes the development of animated table and collection collection easy, because it contains algorithm for calculating differences.
However, it requires to build a data source with multiple sections for table and collection view.
Mostly, we don't need multiple sections in our apps.
To simplify the code for the single section data source, we use the RxDataSourcesSingleSection library.

- RxBinding (https://github.com/RxSwiftCommunity/RxBinding)
RxBinding provides `~>`, `<~>` and `~` operators for data binding using RxSwift, to replace the `bind(to:)` and `disposed(by:)` method in RxSwift.
