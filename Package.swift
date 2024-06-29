// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AIReceiptScanner",
    platforms: [
        .iOS(.v17),
        .watchOS(.v9),
        .macOS(.v14),
        .tvOS(.v17),
        .visionOS(.v1)],
    products: [
        .library(
            name: "AIReceiptScanner",
            targets: ["AIReceiptScanner"]),
    ],
    dependencies: [
        .package(url: "https://github.com/alfianlosari/ChatGPTSwift.git", from: "2.3.1")
    ],
    targets: [
        .target(
            name: "AIReceiptScanner",
            dependencies: [
                "ChatGPTSwift"
            ]
        ),

    ]
)
