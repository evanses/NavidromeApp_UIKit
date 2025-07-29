import UIKit

final class AppRouter {
    static let shared = AppRouter()

    private init() {}

    private var window: UIWindow?

    func setWindow(_ window: UIWindow) {
        self.window = window
    }

    func startApp() {
        if KeychainManager.shared.isAuthorized() {
            showMainInterface(animated: false)
        } else {
            showLogin(animated: false)
        }
    }

    func showLogin(animated: Bool = true) {
        let loginVM = LoginViewModel()
        let loginVC = LoginViewController(viewModel: loginVM)
        setRootViewController(loginVC, animated: animated)
    }

    func showMainInterface(animated: Bool = true) {
        let startLibraryVC = StartLibraryViewController()
        let nav = UINavigationController(rootViewController: startLibraryVC)
        nav.tabBarItem = UITabBarItem(title: "Библиотека", image: UIImage(systemName: "house"), tag: 0)
        
        let settingsMV = SettingsViewModel()
        let settingsVC = SettingsViewController(viewModel: settingsMV)
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gearshape"), tag: 1)

        let tabBar = MainTabBarController()
        tabBar.viewControllers = [nav, settingsVC]
        tabBar.selectedIndex = 0

        PlayerManager.shared.delegate = tabBar.miniPlayerView

        setRootViewController(tabBar, animated: animated)
    }

    private func setRootViewController(_ vc: UIViewController, animated: Bool) {
        guard let window = window else {
            assertionFailure("AppRouter window not set")
            return
        }

        if animated {
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                window.rootViewController = vc
            })
        } else {
            window.rootViewController = vc
        }

        window.makeKeyAndVisible()
    }
}
