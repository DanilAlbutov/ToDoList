import UIKit

protocol HomeViewInput: AnyObject {
    func setupInitialState()
    func displayList(items: [TaskCollectionViewCellConfiguration])
    func updateItem(
        with id: String,
        for items: [TaskCollectionViewCellConfiguration]?
    )
    func presentShareSheet(text: String)
}

protocol HomeViewOutput: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func searchTextDidChange(_ text: String)
    func taskSelectionDidChange(taskID: String, isSelected: Bool)
    func checkButtonTapped(taskID: String)
    func didTapCreateTask()
    func didTapEdit(taskID: String)
    func didTapShare(taskID: String)
    func didTapDelete(taskID: String)
}

protocol HomeInteractorInput: AnyObject {
    func onLoad()
    func loadStoredTasks()
    func saveTaskSelection(taskID: String, isSelected: Bool)
    func deleteTask(taskID: String)
}

protocol HomeInteractorOutput: AnyObject {
    func listLoaded(model: ToDoListResponse)
}

protocol HomeRouterInput: AnyObject {
    func openCreateTask(moduleOutput: DetailsModuleOutput?)
    func openEditTask(taskID: String, moduleOutput: DetailsModuleOutput?)
}
