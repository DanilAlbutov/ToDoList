import Foundation

final class HomePresenter: HomeViewOutput, HomeInteractorOutput, DetailsModuleOutput {
    weak var view: HomeViewInput?
    var interactor: HomeInteractorInput?
    var router: HomeRouterInput?
    
    private var visibleItems: [TaskCollectionViewCellConfiguration] {
        makeVisibleItems()
    }

    private var allItems: [TaskItem] = []
    
    private var currentSearchText: String = ""
    
    private func itemIndex(with id: String) -> Int? {
        allItems.firstIndex(where: { $0.id == id })
    }
    
    // MARK: - Private methods
    
    private func makeVisibleItems() -> [TaskCollectionViewCellConfiguration] {
        let trimmedText = currentSearchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            return allItems.map(\.cellConfiguration)
        }

        let normalizedQuery = trimmedText.lowercased()
        return allItems
            .filter {
                $0.todo.lowercased().contains(normalizedQuery)
                || ($0.detailsText?.lowercased().contains(normalizedQuery) ?? false)
            }
            .map(\.cellConfiguration)
    }

    // MARK: - HomeViewOutput

    func viewDidLoad() {
        view?.setupInitialState()
        view?.showLoading()
        interactor?.onLoad()
    }
    
    func viewWillAppear() {
        interactor?.loadStoredTasks()
    }

    func searchTextDidChange(_ text: String) {
        currentSearchText = text
        view?.displayList(items: visibleItems)
    }

    func taskSelectionDidChange(taskID: String, isSelected: Bool) {
        interactor?.saveTaskSelection(taskID: taskID, isSelected: isSelected)

        guard let index = itemIndex(with: taskID) else { return }

        allItems[index] = allItems[index].updated(completed: isSelected)
        guard visibleItems.contains(where: { $0.id == taskID }) else {
            return
        }
        view?.updateItem(with: taskID, for: visibleItems)
    }

    func checkButtonTapped(taskID: String) {
        guard let index = itemIndex(with: taskID) else { return }
        let isSelected = !allItems[index].completed
        taskSelectionDidChange(taskID: taskID, isSelected: isSelected)
    }
    
    func didTapCreateTask() {
        router?.openCreateTask(moduleOutput: self)
    }

    func didTapEdit(taskID: String) {
        router?.openEditTask(taskID: taskID, moduleOutput: self)
    }

    func didTapShare(taskID: String) {
        guard let item = allItems.first(where: { $0.id == taskID }) else {
            return
        }

        let text = "\(item.todo)\n\n\(item.detailsText ?? "")"
        router?.openShareSheet(with: text)
    }

    func didTapDelete(taskID: String) {
        guard let index = itemIndex(with: taskID) else { return }

        allItems.remove(at: index)
        interactor?.deleteTask(taskID: taskID)
        view?.displayList(items: visibleItems)
    }
    
    // MARK: - HomeInteractorOutput
    
    func listLoaded(items: [TaskItem]) {
        allItems = items
        view?.hideLoading()
        view?.displayList(items: visibleItems)
    }

    func listLoadingFailed(message: String) {
        view?.hideLoading()
        router?.openErrorAlert(message: message)
    }
    
    // MARK: - DetailsModuleOutput
    
    func detailsModuleDidFinishCreatingTask() {
        interactor?.loadStoredTasks()
    }
    
    func detailsModuleDidFinishEditing(taskWith Id: String) {
        interactor?.loadStoredTasks()
        view?.updateItem(with: Id, for: nil)
    }
}

fileprivate extension TaskItem {
    func updated(completed: Bool) -> TaskItem {
        .init(
            id: id,
            todo: todo,
            completed: completed,
            userID: userID,
            detailsText: detailsText,
            createdAt: createdAt
        )
    }
    
    var cellConfiguration: TaskCollectionViewCellConfiguration {
        .init(
            id: id,
            infoConfig: .init(
                title: todo,
                description: detailsText ?? "User id: \(userID), task id: \(id)",
                date: (createdAt ?? Date()).formattedString,
                isCompleted: completed
            )
        )
    }
}
