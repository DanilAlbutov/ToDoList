import Foundation

final class HomeInteractor: HomeInteractorInput {
    weak var output: HomeInteractorOutput?
    var networkService: TDLNetworkServiceI?
    
    // MARK: - HomeInteractorInput
    
    func onLoad() {
        networkService?.getList { [weak self] result in
            switch result {
            case .success(let list):
                print("-- success \(list)")
            case .failure(let error):
                print("-- error \(error)")
            }
        }
    }
}
