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
                let networkItems = list.todos.map(TaskItem.init(responseItem:))
                self?.taskItemsStorage?.save(items: networkItems, overrideOldCompletion: needOverride)
                let storedItems = self?.taskItemsStorage?.loadItems() ?? networkItems
                self?.output?.listLoaded(items: storedItems)
            case .failure(let error):
                let storedItems = self?.taskItemsStorage?.loadItems() ?? []
                if !storedItems.isEmpty {
                    self?.output?.listLoaded(items: storedItems)
                } else {
                    self?.output?.listLoadingFailed(message: error.localizedDescription)
                }
            }
        }
    }
    
    func loadStoredTasks() {
        let storedItems = taskItemsStorage?.loadItems() ?? []
        output?.listLoaded(items: storedItems)
    }

    func saveTaskSelection(taskID: String, isSelected: Bool) {
        taskItemsStorage?.updateCompletion(for: taskID, isCompleted: isSelected)
    }

    func deleteTask(taskID: String) {
        taskItemsStorage?.deleteItem(with: taskID)
    }
}
