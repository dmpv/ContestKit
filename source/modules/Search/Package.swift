// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Search",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Search",
            targets: ["Search"]),
    ],
    dependencies: [
        .package(path: "../NutsonCore"),
        .package(url: "https://github.com/dmpv/ComponentKit.git", from: "0.1.0"),
        .package(url: "https://github.com/kean/Nuke.git", from: "10.3.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Search",
            dependencies: ["NutsonCore", "ComponentKit", "Nuke"]),
        .testTarget(
            name: "SearchTests",
            dependencies: ["Search"]),
    ]
)
