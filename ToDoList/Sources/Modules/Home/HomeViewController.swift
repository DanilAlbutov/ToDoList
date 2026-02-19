import UIKit

final class HomeViewController: UIViewController {
    var output: HomeViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
}

extension HomeViewController: HomeViewInput {
    func setupInitialState() {
    }
}