//
//  SceneDelegate.swift
//  RXSwiftDemo
//
//  Created by temptempest on 25.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        // 1   - TestFirstViewController()
        // 1.1 - MainViewAssembly.configure()
        // 2   - TestSecondViewController()
        // 2.1 - TaskListAssembly.configure()
        // 3   - TestThirdViewController()
        // 3.1 - WeatherAssembly.configure()
        // 4   - TestFourthViewController()
        // 4.1 - ArticleAssembly.configure()
        window?.rootViewController = ArticleAssembly.configure()
        window?.makeKeyAndVisible()
    }
}
