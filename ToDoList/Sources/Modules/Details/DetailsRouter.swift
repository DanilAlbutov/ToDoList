import UIKit

final class DetailsRouter: DetailsRouterInput {
    weak var viewController: UIViewController?
    
    func close() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
