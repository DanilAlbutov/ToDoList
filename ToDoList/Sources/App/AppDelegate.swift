import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDIContainer.shared.registerAssembly()
        configureWindow()
        startFlow()
        return true
    }
    
    private func startFlow() {
        guard let startViewController = HomeAssembly.createModule() else { return assertionFailure("HomeAssembly.createModule() return nil") }
        window?.rootViewController = UINavigationController(rootViewController: startViewController)            
    }
    
    private func configureWindow() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)            
            let viewController = UIViewController()
            viewController.view.backgroundColor = .red
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
