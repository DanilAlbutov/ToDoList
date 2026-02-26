import Foundation

final class HomeInteractor: HomeInteractorInput {
    weak var output: HomeInteractorOutput?
    var networkService: TDLNetworkServiceI?
    var taskItemsStorage: TaskItemsStorage?
    
    // MARK: - HomeInteractorInput
    
    func onLoad() {
        networkService?.getList { [weak self] result in
            switch result {
            case .success(let list):
                let needOverride = self?.taskItemsStorage?.loadItems().isEmpty == true
                self?.taskItemsStorage?.save(items: list.todos, overrideOldCompletion: needOverride)
                let storedItems = self?.taskItemsStorage?.loadItems() ?? list.todos
                let response = ToDoListResponse(
                    todos: storedItems,
                    total: list.total,
                    skip: list.skip,
                    limit: list.limit
                )
                self?.output?.listLoaded(model: response)
            case .failure(let error):
                let storedItems = self?.taskItemsStorage?.loadItems() ?? []
                if !storedItems.isEmpty {
                    let response = ToDoListResponse(
                        todos: storedItems,
                        total: storedItems.count,
                        skip: .zero,
                        limit: storedItems.count
                    )
                    self?.output?.listLoaded(model: response)
                } else {
                    // TODO: - present error
                }
            }
        }
    }
    
    func loadStoredTasks() {
        let storedItems = taskItemsStorage?.loadItems() ?? []
        let response = ToDoListResponse(
            todos: storedItems,
            total: storedItems.count,
            skip: .zero,
            limit: storedItems.count
        )
        output?.listLoaded(model: response)
    }

    func saveTaskSelection(taskID: String, isSelected: Bool) {
        taskItemsStorage?.updateCompletion(for: taskID, isCompleted: isSelected)
    }

    func deleteTask(taskID: String) {
        taskItemsStorage?.deleteItem(with: taskID)
    }
}
