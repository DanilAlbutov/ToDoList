import Swinject
import UIKit

final class HomeAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeViewController.self) { _ in
            HomeViewController()
        }.initCompleted { resolver, view in
            view.output = resolver.resolve(HomeViewOutput.self, argument: view)
        }
        
        container.register(TDLNetworkServiceI.self) { _ in TDLNetworkService() }
        container.register(CoreDataStack.self) { _ in CoreDataStack() }
            .inObjectScope(.container)
        container.register(TaskItemsStorage.self) { resolver in
            let coreDataStack = resolver.resolve(CoreDataStack.self) ?? CoreDataStack()
            return CoreDataTaskItemsStorage(coreDataStack: coreDataStack)
        }.inObjectScope(.container)

        container.register(HomeInteractorInput.self) { resolver in 
            let interactor = HomeInteractor() 
            interactor.networkService = resolver.resolve(TDLNetworkServiceI.self)
            interactor.taskItemsStorage = resolver.resolve(TaskItemsStorage.self)
            return interactor
        }
        container.register(HomeRouterInput.self) { (_, view: HomeViewController) in
            let router = HomeRouter()
            router.viewController = view
            return router
        }
        
        container.register(HomeViewOutput.self) { (resolver, view: HomeViewController) in
            let presenter = HomePresenter()
            presenter.view = view
            presenter.interactor = resolver.resolve(HomeInteractorInput.self)
            presenter.router = resolver.resolve(HomeRouterInput.self, argument: view)
            
            if let interactor = presenter.interactor as? HomeInteractor {
                interactor.output = presenter
            }
            return presenter
        }
    }
    
    static func createModule() -> UIViewController? {
        guard let viewController = AppDIContainer.shared.resolve(
            HomeViewController.self
        ) else {
            assertionFailure("incorrect DI resolving HomeViewController")
            return nil 
        }
        let presenter = AppDIContainer.shared.resolve(HomeViewOutput.self, argument: viewController)
        
        viewController.output = presenter
        return viewController
    }
}
