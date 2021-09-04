// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "IdentityApi",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "IdentityApi", targets: ["IdentityApi"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("5.4.3")),
    ],
    targets: [
        .target(name: "IdentityApi", dependencies: [
          "Alamofire",
        ], path: "Sources")
    ]
)
