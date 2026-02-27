//
//  MockRouter.swift
//  ToDoList
//
//  Created by Данил Албутов on 27.02.2026.
//

@testable import ToDoList

final class MockRouter: HomeRouterInput {
    var openCreateTaskCalled = false
    var openEditTaskArgs: (taskID: String, output: DetailsModuleOutput?)?
    var openErrorAlertArg: String?
    var openShareSheetArg: String?

    func openCreateTask(moduleOutput: DetailsModuleOutput?) { openCreateTaskCalled = true }
    func openEditTask(taskID: String, moduleOutput: DetailsModuleOutput?) {
        openEditTaskArgs = (taskID, moduleOutput)
    }
    func openErrorAlert(message: String) { openErrorAlertArg = message }
    func openShareSheet(with text: String) { openShareSheetArg = text }
}
