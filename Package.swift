// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "scandit-datacapture-frameworks-label",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ScanditFrameworksLabel",
            targets: ["ScanditFrameworksLabel"]
        ),
    ],
    dependencies: [
        .package(path: "../scandit-datacapture-frameworks-core"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Objective-C target for validation flow defaults
        .target(
            name: "ScanditFrameworksLabelObjC",
            dependencies: [
                "ScanditLabelCapture"
            ],
            path: "Sources/ScanditFrameworksLabelObjC",
            publicHeadersPath: "."),
        .target(
            name: "ScanditFrameworksLabel",
            dependencies: [
                .product(name: "ScanditFrameworksCore", package: "scandit-datacapture-frameworks-core"),
                "ScanditLabelCapture",
                "ScanditFrameworksLabelObjC"
            ]
        ),
        .binaryTarget(
            name: "ScanditLabelCapture",
            path: "Frameworks/ScanditLabelCapture.xcframework"
        ),
    ]
)
