// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "ContrastWeb",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura", from: "2.7.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-Compression.git", from: "2.2.2"),
        .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", from: "1.11.1"),
        .package(url: "https://github.com/soffes/Color", from: "0.1.2"),
        .package(url: "https://github.com/soffes/Cairo", .revision("831b30aae59bb11342a001775ae31cda288fcfd1"))
    ],
    targets: [
        .target(name: "ContrastWeb", dependencies: ["Kitura", "KituraCompression", "KituraStencil", "Color", "Cairo"]),
        .testTarget(name: "ContrastWebTests", dependencies: ["ContrastWeb"])
    ]
)
