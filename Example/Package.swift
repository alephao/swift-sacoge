// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Example",
    platforms: [
      .macOS(.v14),
    ],
    products: [
      .executable(name: "Example", targets: ["Example"]),
    ],
    dependencies: [
      .package(name: "swift-sacoge", path: "../"),
      .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
      .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.0.0"),
      .package(url: "https://github.com/alephao/swift-sacoge-hummingbird.git", revision: "09314f8"),
    ],
    targets: [
      .executableTarget(
          name: "Example",
          dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "Hummingbird", package: "hummingbird"),
            .product(name: "SacogeHummingbird", package: "swift-sacoge-hummingbird"),
          ],
          plugins: [
            .plugin(name: "SacogePlugin", package: "swift-sacoge"),
          ]
        ),
    ]
)
