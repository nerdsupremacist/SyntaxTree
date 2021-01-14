// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SyntaxTree",
    products: [
        .library(name: "SyntaxTree",
                 targets: ["SyntaxTree"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SyntaxTree",
                dependencies: []),
    ]
)
