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
            sources: [
                "ToDoList/Sources/**",
                "Derived/Sources/**",
                "Generated/Sources/**"
            ],
            resources: ["ToDoList/Resources/**"],
            scripts: [
                .pre(
                    script: "\"$SRCROOT/scripts/generate_uicolor_assets.sh\"",
                    name: "Generate UIColor Extension",
                    inputPaths: [
                        "$SRCROOT/Derived/Sources/TuistAssets+ToDoList.swift"
                    ],
                    outputPaths: [
                        "$SRCROOT/Generated/Sources/UIColor+AppColors.generated.swift"
                    ]
                )
            ],
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
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            buildableFolders: [
                "ToDoList/Tests"
            ],
            dependencies: [.target(name: "ToDoList")]
        ),
    ]
)
