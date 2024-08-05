// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWSimpleGeminiAI",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "WWSimpleGeminiAI", targets: ["WWSimpleGeminiAI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/William-Weng/WWNetworking.git", from: "1.6.2"),
    ],
    targets: [
        .target(name: "WWSimpleGeminiAI", dependencies: ["WWNetworking"], resources: [.copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
