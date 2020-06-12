// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PBOTPKit",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "PBOTPKit",
            targets: ["PBOTPKit"]),
        .library(
            name: "PBHOTPGenerator",
            targets: ["PBHOTPGenerator"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "PBBase32", url: "https://github.com/websurgeon/swift-pbBase32.git", from: "1.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "PBOTPKit",
            dependencies: ["PBHOTPGenerator"]),
        .testTarget(
            name: "PBOTPKitTests",
            dependencies: ["PBOTPKit"]),
        .target(
            name: "PBHOTPGenerator",
            dependencies: ["PBBase32"]),
        .testTarget(
            name: "PBHOTPGeneratorTests",
            dependencies: ["PBHOTPGenerator"]),
    ]
)
