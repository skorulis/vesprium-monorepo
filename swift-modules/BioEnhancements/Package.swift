// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BioEnhancements",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "BioEnhancements",
            targets: ["BioEnhancements"]
        )
    ],
    dependencies: [
        .package(path: "../BioStats"),
        .package(path: "../Util")
    ],
    targets: [
        .target(
            name: "BioEnhancements",
            dependencies: [
                .product(name: "BioStats", package: "BioStats"),
                .product(name: "Util", package: "Util")
            ]
        ),
        .testTarget(
            name: "BioEnhancementsTests",
            dependencies: ["BioEnhancements"]
        )
    ]
)
