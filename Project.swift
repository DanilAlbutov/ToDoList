import ProjectDescription

let project = Project(
    name: "ToDoList",
    targets: [
        .target(
            name: "ToDoList",
            destinations: .iOS,
            product: .app,
            bundleId: "com.albutov.ToDoList",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchStoryboardName": "LaunchScreen",
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": false,
                    "UISceneConfigurations": [:]
                ],
                "UIUserInterfaceStyle": "Light",
            ]),
            sources: ["ToDoList/Sources/**"], 
            resources: ["ToDoList/Resources/**"],
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "SnapKit"),
                .external(name: "Swinject")
            ]
        ),
        .target(
            name: "ToDoListTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.ToDoListTests",
            infoPlist: .default,
            buildableFolders: [
                "ToDoList/Tests"
            ],
            dependencies: [.target(name: "ToDoList")]
        ),
    ]
)
