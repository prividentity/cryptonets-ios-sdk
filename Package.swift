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
                    ),
                    .target(
                        name: "TensorFlowLite"
                    )
                ]
        ),
        .binaryTarget(name: "privid_fhe", path: "./privid_fhe.xcframework"),
        .binaryTarget(name: "TensorFlowLite", path: "./TensorFlowLite.xcframework"),
    ]
)
