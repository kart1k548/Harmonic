import UIKit

protocol TabBarViewControllerProtocol: AnyObject {
    func didReceiveProfile(profile: UserProfile?)
}

class TabBarViewController: UITabBarController {
    var presenter: TabBarPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear()
    }
    
    func styleTabBar() {
        tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .darkBgColor
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .darkBgColor
        tabBar.scrollEdgeAppearance = tabBarAppearance
        tabBar.standardAppearance = tabBarAppearance
        tabBar.tintColor = .lightestPurple
        tabBar.unselectedItemTintColor = .systemGray
    }
    
    func prepareTabBar(profile: UserProfile?) {
        let homeVC = HomeViewController()
        let libraryVC = LibraryViewController()
        let settingsVC = SettingsViewController()
        
        homeVC.presenter = HomePresenter(view: homeVC, model: HomeModel(profile: profile))
        settingsVC.profile = profile
        
        let homeTab = UINavigationController(rootViewController: homeVC)
        let libraryTab = UINavigationController(rootViewController: libraryVC)
        let settingsTab = UINavigationController(rootViewController: settingsVC)
        
        homeTab.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        libraryTab.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 2)
        settingsTab.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), tag: 3)
        
        setViewControllers([homeTab, libraryTab, settingsTab], animated: false)
    }
}

extension TabBarViewController: TabBarViewControllerProtocol {
    func didReceiveProfile(profile: UserProfile?) {
        prepareTabBar(profile: profile)
    }
}
