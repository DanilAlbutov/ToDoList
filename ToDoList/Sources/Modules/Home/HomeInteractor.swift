import Foundation

final class HomeInteractor: HomeInteractorInput {
    weak var output: HomeInteractorOutput?
    var networkService: TDLNetworkServiceI?
    var taskItemsStorage: TaskItemsStorage?
    
    // MARK: - HomeInteractorInput
    
    func onLoad() {
        networkService?.getList { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let list):
                let networkItems = list.todos.map(TaskItem.init(responseItem:))      
                loadAndPersistNetworkItems(networkItems)
            case .failure(let error):
                loadStoredItems(onFailureMessage: error.localizedDescription)
            }
        }
    }
    
    func loadStoredTasks() {
        taskItemsStorage?.loadItems { [weak self] storedItems in
            self?.output?.listLoaded(items: storedItems)
        }
    }

    func saveTaskSelection(taskID: String, isSelected: Bool) {
        taskItemsStorage?.updateCompletion(for: taskID, isCompleted: isSelected, completion: nil)
    }

    func deleteTask(taskID: String) {
        taskItemsStorage?.deleteItem(with: taskID, completion: nil)
    }
    
    // MARK: - Private methods
    
    private func loadAndPersistNetworkItems(_ networkItems: [TaskItem]) {
        taskItemsStorage?.loadItems { [weak self] existingItems in
            guard let self else { return }
            let shouldOverrideCompletion = existingItems.isEmpty
            self.taskItemsStorage?.save(
                items: networkItems,
                overrideOldCompletion: shouldOverrideCompletion
            ) { [weak self] in
                self?.output?.listLoaded(items: existingItems)                
            }
        }
    }

    private func loadStoredItems(onFailureMessage: String) {
        taskItemsStorage?.loadItems { [weak self] storedItems in
            guard let self else { return }
            if !storedItems.isEmpty {
                self.output?.listLoaded(items: storedItems)
            } else {
                self.output?.listLoadingFailed(message: onFailureMessage)
            }
        }
    }
}
