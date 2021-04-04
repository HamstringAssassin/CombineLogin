//
//  AppDelegate.swift
//  CombineLogin
//
//  Created by Al O'Connor on 3/26/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var loginCoordinator: LoginCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)

        let navigationController = UINavigationController()
        navigationController.view.backgroundColor = .systemBackground
        navigationController.navigationBar.prefersLargeTitles = true

        let loginCoordinator = LoginCoordinator(navigationController)

        self.loginCoordinator = loginCoordinator
        loginCoordinator.start()

        self.window = window

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return true
    }

}

