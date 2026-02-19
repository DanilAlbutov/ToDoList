import UIKit

protocol HomeViewInput: AnyObject {
    func setupInitialState()
}

protocol HomeViewOutput: AnyObject {
    func viewDidLoad()
}

protocol HomeInteractorInput: AnyObject {
}

protocol HomeInteractorOutput: AnyObject {
}

protocol HomeRouterInput: AnyObject {
}