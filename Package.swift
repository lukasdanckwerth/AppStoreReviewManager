// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppStoreReviewManager",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "AppStoreReviewManager",
            targets: ["AppStoreReviewManager"]),
    ],
    targets: [
        .target(
            name: "AppStoreReviewManager",
            dependencies: []),
        .testTarget(
            name: "AppStoreReviewManagerTests",
            dependencies: ["AppStoreReviewManager"]),
    ]
)
