// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Utils",
    products: [
        .library(
            name: "Utils",
            targets: ["Utils"]),
    ],
    targets: [
        .target(
            name: "Utils",
            dependencies: []),
        .testTarget(
            name: "UtilsTests",
            dependencies: ["Utils"]),
    ]
)
