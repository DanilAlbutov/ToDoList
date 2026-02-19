import Foundation

final class HomePresenter {
    weak var view: HomeViewInput?
    var interactor: HomeInteractorInput?
    var router: HomeRouterInput?
}

extension HomePresenter: HomeViewOutput {
    func viewDidLoad() {
        view?.setupInitialState()
        interactor?.onLoad()
    }
}

extension HomePresenter: HomeInteractorOutput { }