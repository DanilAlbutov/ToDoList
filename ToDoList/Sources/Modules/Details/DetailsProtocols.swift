import UIKit

protocol DetailsModuleOutput: AnyObject {
    func detailsModuleDidFinishEditing(taskWith Id: String)
    func detailsModuleDidFinishCreatingTask()
}

struct DetailsViewModel {
    let title: String
    let description: String
    let dateText: String
    let saveButtonTitle: String
}

protocol DetailsViewInput: AnyObject {
    func setupInitialState(with viewModel: DetailsViewModel)
    func updateSaveButton(isEnabled: Bool)
}

protocol DetailsViewOutput: AnyObject {
    func viewDidLoad()
    func titleDidChange(_ text: String)
    func didTapSave(title: String, description: String)
}

protocol DetailsInteractorInput: AnyObject {
    func loadTask(taskID: String?)
    func saveTask(taskID: String?, title: String, description: String)
}

protocol DetailsInteractorOutput: AnyObject {
    func didLoadTask(item: ToDoListResponse.Item?)
    func didSaveTask()
}

protocol DetailsRouterInput: AnyObject {
    func close()
}
