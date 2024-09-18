// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Example",
    platforms: [
      .macOS(.v13),
    ],
    products: [
      .executable(name: "Example", targets: ["Example"]),
    ],
    dependencies: [
      .package(name: "swift-sacoge", path: "../"),
    ],
    targets: [
      .executableTarget(
          name: "Example",
          plugins: [
            .plugin(name: "SacogePlugin", package: "swift-sacoge"),
          ]
        ),
    ]
)
