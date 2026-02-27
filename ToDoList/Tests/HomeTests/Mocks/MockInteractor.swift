//
//  MockInteractor.swift
//  ToDoList
//
//  Created by Данил Албутов on 27.02.2026.
//

@testable import ToDoList

final class MockInteractor: HomeInteractorInput {
    var onLoadCalled = false
    var loadStoredTasksCalled = false
    var saveTaskSelectionArgs: (taskID: String, isSelected: Bool)?
    var deleteTaskArg: String?

    func onLoad() { onLoadCalled = true }
    func loadStoredTasks() { loadStoredTasksCalled = true }
    func saveTaskSelection(taskID: String, isSelected: Bool) {
        saveTaskSelectionArgs = (taskID, isSelected)
    }
    func deleteTask(taskID: String) { deleteTaskArg = taskID }
}
