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
        
        let locationProvider = CoreLocationProvider()
        let weatherApi = WeatherApi()
        let crawlingService = CrawlingService()
        
        let homeVM = HomeViewModel(locationProvider: locationProvider, weatherApi: weatherApi, crawlingService: crawlingService)
        let homeVC = HomeViewController(viewModel: homeVM)
        let homeNav = makeNav(
            unselectedImage: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill"),
            rootViewController: homeVC)
        
        window.rootViewController = homeNav
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
}

extension SceneDelegate {
    
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

