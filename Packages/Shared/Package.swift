// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Shared",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Shared",
            targets: ["Shared"]),
    ],
    dependencies: [
        .package(url: "https://github.com/samalone/websocket-actor-system.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-distributed-actors", branch: "main")
    ],
    targets: [
        .target(
            name: "Shared",
            dependencies: [
                .product(name: "WebSocketActors", package: "websocket-actor-system"),
                .product(name: "DistributedCluster", package: "swift-distributed-actors")
            ]),
    ]
)
