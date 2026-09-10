// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "RxController",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "RxController", targets: ["RxController"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.10.2")),
        .package(url: "https://github.com/RxSwiftCommunity/RxFlow.git", .upToNextMajor(from: "2.13.0"))
    ],
    targets: [
        .target(
            name: "RxController",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxFlow", package: "RxFlow")
            ],
            path: "RxController"
        )
    ],
    swiftLanguageVersions: [.v5]
)
