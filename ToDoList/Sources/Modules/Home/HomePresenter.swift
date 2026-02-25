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
        view?.updateCompletionStateForItem(with: taskID, for: items)
    }

    func checkButtonTapped(taskID: String) {
        guard let index = items.firstIndex(where: { $0.id == taskID }) else {
            return
        }
        let isSelected = !items[index].isCompleted
        taskSelectionDidChange(taskID: taskID, isSelected: isSelected)
    }

    func didTapEdit(taskID: String) {
        router?.openEditTask(taskID: taskID)
    }

    func didTapShare(taskID: String) {
        guard let item = items.first(where: { $0.id == taskID }) else {
            return
        }

        let text = "\(item.title)\n\n\(item.description)"
        view?.presentShareSheet(text: text)
    }

    func didTapDelete(taskID: String) {
        guard let index = items.firstIndex(where: { $0.id == taskID }) else {
            return
        }

        items.remove(at: index)
        interactor?.deleteTask(taskID: taskID)
        view?.displayList(items: items)
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
