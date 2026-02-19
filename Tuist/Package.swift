// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
         productTypes: ["Alamofire": .framework,]
    )
#endif

let package = Package(
    name: "ToDoList",
    dependencies: [
         .package(url: "https://github.com/Alamofire/Alamofire", from: "5.11.1"),
         .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1"),
         .package(url: "https://github.com/Swinject/Swinject", from: "2.8.0")
    ]
)
