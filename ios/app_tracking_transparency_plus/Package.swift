// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "app_tracking_transparency_plus",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "app-tracking-transparency-plus", targets: ["app_tracking_transparency_plus"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "app_tracking_transparency_plus",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
