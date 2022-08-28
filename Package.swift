// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HTTP",
    platforms: [
        .iOS("15.0"),
        .macOS("12.0")
    ],
    products: [
        .library(
            name: "HTTP",
            targets: ["HTTP"]
        )
    ],
    targets: [
        .target(
            name: "HTTP",
            path: "HTTP",
            exclude: ["Supporting Files/HTTP.docc"]
        ),
        .testTarget(
            name: "HTTPTests",
            dependencies: ["HTTP"],
            path: "HTTPTests"
        )
    ]
)
