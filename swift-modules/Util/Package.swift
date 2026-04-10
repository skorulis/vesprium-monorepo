// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Util",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Util",
            targets: ["Util"]
        )
    ],
    targets: [
        .target(
            name: "Util"
        ),
    ]
)
