// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SnowMonkey",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SnowMonkey",
            targets: ["SnowMonkey"]
        ),
    ],
    targets: [
        .target(
            name: "SnowMonkey",
            path: "SnowMonkey/classes",
            sources: [
                "extensions",
                "header",
                "footer",
                "core",
                "collection",
                "table",
                "picker",
                "Config.swift"
            ]
        )
    ]
)
