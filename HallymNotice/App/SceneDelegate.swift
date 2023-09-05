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
        
        let homeVC = HomeViewController()
        let nav = UINavigationController(rootViewController: homeVC)
        window.rootViewController = nav
        
        self.window = window
        window.makeKeyAndVisible()
    }
}

