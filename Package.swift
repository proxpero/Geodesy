// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Geodesy",
    products: [
        .library(
            name: "Geodesy",
            targets: ["Geodesy"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Geodesy",
            path: "Source"),
        .testTarget(
            name: "GeodesyTests",
            dependencies: ["Geodesy"],
            path: "GeodesyTests")
    ]
)
