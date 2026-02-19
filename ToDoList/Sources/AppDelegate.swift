import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureWindow()        
        return true
    }
    
    private func configureWindow() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)            
            let viewController = UIViewController()
            viewController.view.backgroundColor = .red
            window.rootViewController = UINavigationController(rootViewController: viewController)            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
