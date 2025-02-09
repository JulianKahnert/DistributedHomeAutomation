// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Server",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .executable(
            name: "Server",
            targets: ["Server"])
    ],
    dependencies: [
        .package(name: "Shared", path: "../Shared")
    ],
    targets: [
        .executableTarget(
            name: "Server",
            dependencies: [
                .product(name: "Shared", package: "Shared")
            ])
    ]
)
