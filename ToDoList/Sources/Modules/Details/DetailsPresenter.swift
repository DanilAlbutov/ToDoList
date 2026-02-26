import Foundation

final class DetailsPresenter {
    
    enum Mode {
        case edit(taskId: String), create
        var taskId: String? {
            switch self {
            case .edit(let taskId):
                return taskId
            case .create:
                return nil
            }
        }
    }
    weak var view: DetailsViewInput?
    var interactor: DetailsInteractorInput?
    var router: DetailsRouterInput?
    weak var moduleOutput: DetailsModuleOutput?
    
    
    
    var mode: Mode?
    private var currentTask: ToDoListResponse.Item?
}

extension DetailsPresenter: DetailsViewOutput {
    func viewDidLoad() {
        switch mode {
        case .create:
            didLoadTask(item: nil)
        case let .edit(taskId: taskID):
            interactor?.loadTask(taskID: taskID)
        case .none:
            assertionFailure("mode property is required")
            break
        }
        
    }
    
    func titleDidChange(_ text: String) {
        let hasTitle = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        view?.updateSaveButton(isEnabled: hasTitle)
    }
    
    func didTapSave(title: String, description: String) {
        interactor?.saveTask(
            taskID: mode?.taskId,
            title: title,
            description: description
        )        
    }
}

extension DetailsPresenter: DetailsInteractorOutput {
    func didLoadTask(item: ToDoListResponse.Item?) {
        currentTask = item
        let viewModel: DetailsViewModel
        if case .edit = mode {
            viewModel = .init(
                title: item?.todo ?? "",
                description: item?.detailsText ?? "",
                dateText: Date().formattedString,
                saveButtonTitle: "Сохранить"
            )
        } else {
            viewModel = .init(
                title: "",
                description: "",
                dateText: Date().formattedString,
                saveButtonTitle: "Создать"
            )
        }
        view?.setupInitialState(with: viewModel)
        let hasTitle = !viewModel.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        view?.updateSaveButton(isEnabled: hasTitle)
    }
    
    func didSaveTask() {
        if let id = mode?.taskId {
            moduleOutput?.detailsModuleDidFinishEditing(taskWith: "\(id)")
        } else {
            moduleOutput?.detailsModuleDidFinishCreatingTask()
        }
        
        router?.close()
    }
}
