// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuicklySwift",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        // 定义库
        .library(
            name: "QuicklySwift",
            targets: ["QuicklySwift"]),
    ],
    dependencies: [
        // 依赖 SnapKit
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1")
    ],
    targets: [
        // 主 Target
        .target(
            name: "QuicklySwift",
            dependencies: [
                "SnapKit"
            ],
            path: "QuicklySwift/Classes"
        ),
    ]
)