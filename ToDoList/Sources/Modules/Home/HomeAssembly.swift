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
        
        container.register(HomeInteractorInput.self) { resolver in 
            let interactor = HomeInteractor() 
            interactor.networkService = resolver.resolve(TDLNetworkServiceI.self)
            return interactor
        }
        container.register(HomeRouterInput.self) { _ in HomeRouter() }
        
        container.register(HomeViewOutput.self) { (resolver, view: HomeViewController) in
            let presenter = HomePresenter()
            presenter.view = view
            presenter.interactor = resolver.resolve(HomeInteractorInput.self)
            presenter.router = resolver.resolve(HomeRouterInput.self)
            
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
