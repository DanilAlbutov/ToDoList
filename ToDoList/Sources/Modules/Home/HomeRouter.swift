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

    func openErrorAlert(message: String) {
        let title = "Ошибка загрузки"
        let fallbackMessage = "Не удалось загрузить список задач."

        let alertController = UIAlertController(
            title: title,
            message: fallbackMessage,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "ОК", style: .default))
        viewController?.present(alertController, animated: true)
    }
    
    func openShareSheet(with text: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        viewController?.present(activityViewController, animated: true)
    }
}
