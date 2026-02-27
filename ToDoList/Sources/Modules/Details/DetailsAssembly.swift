import Swinject
import UIKit

final class DetailsAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DetailsInteractorInput.self) { r in
            let interactor = DetailsInteractor()
            interactor.taskItemsStorage = r.resolve(TaskItemsStorage.self)
            return interactor
        }

        container.register(DetailsRouterInput.self) { (_, viewController: DetailsViewController) in
            let router = DetailsRouter()
            router.viewController = viewController
            return router
        }
        
        container.register(DetailsViewOutput.self) { (r, viewController: DetailsViewController, mode: DetailsPresenter.Mode) in
            let presenter = DetailsPresenter()
            presenter.view = viewController
            presenter.mode = mode
            presenter.interactor = r.resolve(DetailsInteractorInput.self)
            presenter.router = r.resolve(DetailsRouterInput.self, argument: viewController)
            
            if let interactor = presenter.interactor as? DetailsInteractor {
                interactor.output = presenter
            }
            
            return presenter
        }
    }
    
    static func createModule(mode: DetailsPresenter.Mode, moduleOutput: DetailsModuleOutput?) -> UIViewController? {
        let viewController = DetailsViewController()
        let presenter = AppDIContainer.shared.resolve(
            DetailsViewOutput.self,
            arguments: viewController,
            mode
        )
        if let detailsPresenter = presenter as? DetailsPresenter {
            detailsPresenter.moduleOutput = moduleOutput
        }
        viewController.output = presenter
        return viewController
    }
}
