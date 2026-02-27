@testable import ToDoList

final class MockTaskItemsStorage: TaskItemsStorage {
    var loadItemsCalled = false
    var itemsToReturn: [TaskItem] = []
    var updateCompletionArgs: (taskID: String, isCompleted: Bool)?
    var deleteItemArg: String?
    var saveItemsArgs: ([TaskItem], Bool)?
    
    func loadItems(completion: @escaping ([TaskItem]) -> Void) {
        loadItemsCalled = true
        completion(itemsToReturn)
    }
    func loadItem(with taskID: String, completion: @escaping (TaskItem?) -> Void) {}
    func save(items: [TaskItem], overrideOldCompletion: Bool, completion: (() -> Void)?) {
        saveItemsArgs = (items, overrideOldCompletion)
        completion?()
    }
    func insert(item: TaskItem, completion: (() -> Void)?) {}
    func updateCompletion(for taskID: String, isCompleted: Bool, completion: (() -> Void)?) {
        updateCompletionArgs = (taskID, isCompleted)
        completion?()
    }
    func deleteItem(with taskID: String, completion: (() -> Void)?) {
        deleteItemArg = taskID
        completion?()
    }
}

// MockHomeInteractorOutput.swift
final class MockHomeInteractorOutput: HomeInteractorOutput {
    var listLoadedItems: [TaskItem]?
    var listLoadingFailedMessage: String?
    func listLoaded(items: [TaskItem]) { listLoadedItems = items }
    func listLoadingFailed(message: String) { listLoadingFailedMessage = message }
}
