// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "RxController",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "RxController", targets: ["RxController"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxFlow.git", .upToNextMajor(from: "2.7.0"))
    ],
    targets: [
        .target(name: "RxController", dependencies: ["RxSwift", "RxCocoa", "RxFlow"], path: "RxController")
    ],
    swiftLanguageVersions: [.v5]
)
