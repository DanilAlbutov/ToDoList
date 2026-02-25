import Foundation

final class HomePresenter {
    weak var view: HomeViewInput?
    var interactor: HomeInteractorInput?
    var router: HomeRouterInput?

    private var items: [TaskCollectionViewCellConfiguration] = []
}

extension HomePresenter: HomeViewOutput {
    func viewDidLoad() {
        view?.setupInitialState()
        interactor?.onLoad()
    }

    func taskSelectionDidChange(taskID: String, isSelected: Bool) {
        interactor?.saveTaskSelection(taskID: taskID, isSelected: isSelected)

        guard let index = items.firstIndex(where: { $0.id == taskID }) else {
            return
        }

        items[index].isCompleted = isSelected
        view?.displayList(items: items)
    }

    func checkButtonTapped(at indexPath: IndexPath) {
        guard indexPath.item < items.count else {
            return
        }
        let isSelected = !self.items[indexPath.item].isCompleted
        self.items[indexPath.item].isCompleted = isSelected

        if isSelected {
            view?.selectItem(at: indexPath)
        } else {
            view?.deselectItem(at: indexPath)
        }

        let taskID = self.items[indexPath.item].id
        taskSelectionDidChange(taskID: taskID, isSelected: isSelected)
    }
}

extension HomePresenter: HomeInteractorOutput { 
    func listLoaded(model: ToDoListResponse) {
        items = model.cellConfigurations
        view?.displayList(items: items)
    }
}

fileprivate extension ToDoListResponse {
    var cellConfigurations: [TaskCollectionViewCellConfiguration] {
        todos.map {
            return .init(
                id: "\($0.id)",
                title: $0.todo,
                description: "User id: \($0.userID)",
                date: Date().description,
                isCompleted: $0.completed
            )
        }
    }
}
