// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CombineCli",
	platforms: [.macOS(.v15)],
    products: [
		.executable(
            name: "CombineCli",
            targets: ["CombineCli"]
        ),
    ],
    targets: [
		.executableTarget(
            name: "CombineCli"
        ),

    ],
    swiftLanguageModes: [.v6]
)
