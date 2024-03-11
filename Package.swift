// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CryptonetPackage",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CryptonetPackage",
            targets: ["CryptonetPackage"]),
    ],
    targets: [
        .target(name: "CryptonetPackage",
                dependencies: [
                    .target(
                        name: "privid_fhe"
                    )
                ]
        ),
        .binaryTarget(name: "privid_fhe", path: "./privid_fhe.xcframework")
    ]
)
