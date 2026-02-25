import UIKit

protocol HomeViewInput: AnyObject {
    func setupInitialState()
    func displayList(items: [TaskCollectionViewCellConfiguration])
    func selectItem(at indexPath: IndexPath)
    func deselectItem(at indexPath: IndexPath)
}

protocol HomeViewOutput: AnyObject {
    func viewDidLoad()
    func taskSelectionDidChange(taskID: String, isSelected: Bool)
    func checkButtonTapped(at indexPath: IndexPath)
}

protocol HomeInteractorInput: AnyObject {
    func onLoad()
    func saveTaskSelection(taskID: String, isSelected: Bool)
}

protocol HomeInteractorOutput: AnyObject {
    func listLoaded(model: ToDoListResponse)
}

protocol HomeRouterInput: AnyObject {
}
