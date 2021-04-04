//
//  LoginCoordinator.swift
//  CombineLogin
//
//  Created by Al O'Connor on 3/26/21.
//

import Foundation
import UIKit

final class LoginCoordinator {
    // MARK: - Private Properties
    private let navigationController: UINavigationController?

    // MARK: - Intialization
    init(_ navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    /// Main function of the Coordinator. This will create a `LoginViewController` and present
    /// it in the `NavigationController` used during initialization
    func start() {
        let viewController = LoginViewController()
        viewController.delegate = self
        navigationController?.show(viewController, sender: self)
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func viewController(_ viewController: LoginViewController,
                        didPerformAction action: LoginViewControllerAction) {
        switch action {
        case .login:
            navigationController?.show(CatViewController(), sender: self)
        }
    }
}
