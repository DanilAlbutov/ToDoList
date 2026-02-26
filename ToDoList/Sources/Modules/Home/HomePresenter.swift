import Foundation

final class HomePresenter {
    weak var view: HomeViewInput?
    var interactor: HomeInteractorInput?
    var router: HomeRouterInput?
    
    private var visibleItems: [TaskCollectionViewCellConfiguration] {
        makeVisibleItems()
    }

    private var allItems: [TaskCollectionViewCellConfiguration] = []  
    
    private var currentSearchText: String = ""
    
    private func itemIndex(with id: String) -> Int? {
        allItems.firstIndex(where: { $0.id == id })
    }
    
    private func makeVisibleItems() -> [TaskCollectionViewCellConfiguration] {
        let trimmedText = currentSearchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            return allItems
        }

        let normalizedQuery = trimmedText.lowercased()
        return allItems.filter {
            $0.title.lowercased().contains(normalizedQuery)
            || $0.description.lowercased().contains(normalizedQuery)
        }
    }
}

extension HomePresenter: HomeViewOutput {
    func viewDidLoad() {
        view?.setupInitialState()
        interactor?.onLoad()
    }

    func searchTextDidChange(_ text: String) {
        currentSearchText = text
        view?.displayList(items: visibleItems)
    }

    func taskSelectionDidChange(taskID: String, isSelected: Bool) {
        interactor?.saveTaskSelection(taskID: taskID, isSelected: isSelected)

        guard let index = itemIndex(with: taskID) else { return }

        allItems[index].isCompleted = isSelected
        let oldVisibleIDs = visibleItems.map(\.id)
        let newVisibleIDs = visibleItems.map(\.id)

        guard newVisibleIDs == oldVisibleIDs else {
            view?.displayList(items: visibleItems)
            return
        }

        guard visibleItems.contains(where: { $0.id == taskID }) else {
            return
        }
        view?.updateCompletionStateForItem(with: taskID, for: visibleItems)
    }

    func checkButtonTapped(taskID: String) {
        guard let index = itemIndex(with: taskID) else { return }
        let isSelected = !allItems[index].isCompleted
        taskSelectionDidChange(taskID: taskID, isSelected: isSelected)
    }

    func didTapEdit(taskID: String) {
        router?.openEditTask(taskID: taskID)
    }

    func didTapShare(taskID: String) {
        guard let item = allItems.first(where: { $0.id == taskID }) else {
            return
        }

        let text = "\(item.title)\n\n\(item.description)"
        view?.presentShareSheet(text: text)
    }

    func didTapDelete(taskID: String) {
        guard let index = itemIndex(with: taskID) else { return }

        allItems.remove(at: index)
        interactor?.deleteTask(taskID: taskID)
        view?.displayList(items: visibleItems)
    }
}

extension HomePresenter: HomeInteractorOutput { 
    func listLoaded(model: ToDoListResponse) {
        allItems = model.cellConfigurations
        view?.displayList(items: visibleItems)
    }
}

fileprivate extension ToDoListResponse {
    var cellConfigurations: [TaskCollectionViewCellConfiguration] {
        todos.map {
            return .init(
                id: "\($0.id)",
                title: $0.todo,
                description: "User id: \($0.userID)",
                date: Date().formattedString,
                isCompleted: $0.completed
            )
        }
    }
}
