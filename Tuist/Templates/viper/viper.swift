import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Strict VIPER module template",
    attributes: [nameAttribute],
    items: [
        .file(path: "ToDoList/Sources/Modules/\(nameAttribute)/\(nameAttribute)ViewController.swift", templatePath: "ViewController.stencil"),
        .file(path: "ToDoList/Sources/Modules/\(nameAttribute)/\(nameAttribute)Presenter.swift", templatePath: "Presenter.stencil"),
        .file(path: "ToDoList/Sources/Modules/\(nameAttribute)/\(nameAttribute)Interactor.swift", templatePath: "Interactor.stencil"),
        .file(path: "ToDoList/Sources/Modules/\(nameAttribute)/\(nameAttribute)Router.swift", templatePath: "Router.stencil"),
        .file(path: "ToDoList/Sources/Modules/\(nameAttribute)/\(nameAttribute)Protocols.swift", templatePath: "Protocols.stencil"),
        .file(path: "ToDoList/Sources/Modules/\(nameAttribute)/\(nameAttribute)Assembly.swift", templatePath: "Assembly.stencil")
    ]
)
