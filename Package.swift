// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "swift-sacoge",
  platforms: [
    .macOS(.v13)
  ],
  products: [
    .executable(name: "sacoge", targets: ["sacoge"]),
    .plugin(name: "SacogePlugin", targets: ["SacogePlugin"]),
    .library(name: "SacogeCore", targets: ["SacogeCore"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.12.0"),
  ],
  targets: [
    .executableTarget(
      name: "sacoge",
      dependencies: [
        "SacogeCore",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ]
    ),
    .plugin(
      name: "SacogePlugin",
      capability: .buildTool(),
      dependencies: [
        "sacoge"
      ]
    ),
    .target(
      name: "SacogeCore",
      dependencies: [
        .product(name: "Crypto", package: "swift-crypto")
      ],
      swiftSettings: [
        .enableExperimentalFeature("StrictConcurrency")
      ]
    ),
    .testTarget(
      name: "SacogeCoreTests",
      dependencies: [
        "SacogeCore",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
        .product(name: "InlineSnapshotTesting", package: "swift-snapshot-testing"),
      ]
    ),
  ]
)
