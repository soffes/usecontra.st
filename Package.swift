// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "ContrastWeb",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura", from: "2.7.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-Compression.git", from: "2.2.2"),
        .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", from: "1.11.1"),
        .package(url: "https://github.com/soffes/Color", from: "0.1.2")
    ],
    targets: [
        .target(name: "ContrastWeb", dependencies: ["Kitura", "KituraCompression", "KituraStencil", "Color"]),
        .testTarget(name: "ContrastWebTests", dependencies: ["ContrastWeb"])
    ]
)
