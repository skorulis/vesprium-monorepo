// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BioEnhancements",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "BioEnhancements",
            targets: ["BioEnhancements"]
        ),
    ],
    targets: [
        .target(
            name: "BioEnhancements"
        ),
        .testTarget(
            name: "BioEnhancementsTests",
            dependencies: ["BioEnhancements"]
        ),
    ]
)
