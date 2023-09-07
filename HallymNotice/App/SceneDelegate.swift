//
//  SceneDelegate.swift
//  HallymNotice
//
//  Created by 이은재 on 2023/09/05.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let tabBarController = makeTabBarController()
        
        window.rootViewController = tabBarController
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
}

extension SceneDelegate {
    
    private func makeTabBarController() -> UITabBarController {
        let locationProvider = CoreLocationProvider()
        let weatherApi = WeatherApi()
        
        let homeVM = HomeViewModel(locationProvider: locationProvider, weatherApi: weatherApi)
        let homeVC = HomeViewController(viewModel: homeVM)
        let homeNav = makeNav(
            unselectedImage: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill"),
            rootViewController: homeVC)
        
        
        let mapVC = MapViewController()
        let mapNav = makeNav(
            unselectedImage: UIImage(systemName: "map"),
            selectedImage: UIImage(systemName: "map.fill"),
            rootViewController: mapVC)
        
        let menuVC = MenuViewController()
        let menuNav = makeNav(
            unselectedImage: UIImage(systemName: "line.3.horizontal"),
            selectedImage: UIImage(systemName: "line.3.horizontal"),
            rootViewController: menuVC)
        
        let tabBarController = UITabBarController()
        
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.setViewControllers([
            mapNav,
            homeNav,
            menuNav
        ], animated: true)
        tabBarController.selectedIndex = 1
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = ThemeColor.primary
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = ThemeColor.gray
        tabBarController.tabBar.standardAppearance = tabBarAppearance
        
        return tabBarController
    }
    
    private func makeNav(
        unselectedImage: UIImage?,
        selectedImage: UIImage?,
        rootViewController: UIViewController
    ) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        return nav
    }
    
}

