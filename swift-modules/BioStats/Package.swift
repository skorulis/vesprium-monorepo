// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BioStats",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "BioStats",
            targets: ["BioStats"]
        ),
    ],
    targets: [
        .target(
            name: "BioStats"
        ),
        .testTarget(
            name: "BioStatsTests",
            dependencies: ["BioStats"]
        ),
    ]
)
