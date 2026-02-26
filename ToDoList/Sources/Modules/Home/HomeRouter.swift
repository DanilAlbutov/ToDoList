import UIKit

final class HomeRouter: HomeRouterInput {
    weak var viewController: UIViewController?
    
    func openCreateTask(moduleOutput: DetailsModuleOutput?) {
        guard let detailsViewController = DetailsAssembly.createModule(
            mode: .create,
            moduleOutput: moduleOutput
        ) else {
            return
        }
        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func openEditTask(taskID: String, moduleOutput: DetailsModuleOutput?) {
        guard let detailsViewController = DetailsAssembly.createModule(
            mode: .edit(taskId: taskID),
            moduleOutput: moduleOutput
        ) else {
            return
        }
        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
