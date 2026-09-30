// swift-tools-version: 6.1
// This is a Skip (https://skip.dev) package.
import PackageDescription

let package = Package(
    name: "str-common-skp",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "STRCommonSkp", type: .dynamic, targets: ["STRCommonSkp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/skiptools/skip.git", from: "1.9.12"),
        .package(url: "https://github.com/skiptools/skip-fuse.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "STRCommonSkp", dependencies: [
            .product(name: "SkipFuse", package: "skip-fuse")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "STRCommonSkpTests", dependencies: [
            "STRCommonSkp",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
