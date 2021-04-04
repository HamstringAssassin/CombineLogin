//
//  LoginViewController.swift
//  CombineLogin
//
//  Created by Al O'Connor on 3/26/21.
//

import UIKit
import Combine

enum LoginViewControllerAction {
    /// login action
    case login
}

protocol LoginViewControllerDelegate: class {
    func viewController(_ viewController: LoginViewController,
                        didPerformAction action: LoginViewControllerAction)
}

final class LoginViewController: UIViewController {
    private var logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "octocat"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let usernameImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.fill"))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .lightGray
        return image
    }()

    private let passwordImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "key.fill"))
        image.contentMode = .scaleAspectFit
        image.tintColor = .lightGray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        return textField
    }()

    private var loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.backgroundColor = UIColor.colorFromHex("5AABEC")
        button.isHidden = true
        return button
    }()

    private var viewModel: LoginViewModel = LoginViewModel()

    private var subscriptions = Set<AnyCancellable>()

    weak var delegate: LoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        setStyling()
        setBindings(viewModel)
    }

    private func setStyling() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Login"
        edgesForExtendedLayout = []
    }

    private func createUI() { }

    private func layoutUI() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        let passwordStackView = UIStackView()
        passwordStackView.spacing = 10

        let usernameStackView = UIStackView()
        usernameStackView.spacing = 10

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            usernameTextField.heightAnchor.constraint(equalToConstant: 42),
            passwordTextField.heightAnchor.constraint(equalToConstant: 42),
            loginButton.heightAnchor.constraint(equalToConstant: 42),
            logoImage.heightAnchor.constraint(equalToConstant: 100),
            passwordImage.widthAnchor.constraint(equalToConstant: 25),
            usernameImage.widthAnchor.constraint(equalToConstant: 25)
        ])
        stackView.addArrangedSubview(logoImage)
        stackView.addArrangedSubview(usernameStackView)
        stackView.addArrangedSubview(passwordStackView)
        usernameStackView.addArrangedSubview(usernameImage)
        usernameStackView.addArrangedSubview(usernameTextField)
        passwordStackView.addArrangedSubview(passwordImage)
        passwordStackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
    }

    private func setBindings(_ viewModel: LoginViewModel) {
        viewModel.passwordTextFieldBackgroundColor(passwordTextField.textPublisher)
            .sink(receiveValue: { [weak self] in
                self?.passwordTextField.backgroundColor = $0
            })
            .store(in: &subscriptions)

        viewModel.userNameTextFieldBackgroundColor(usernameTextField.textPublisher)
            .sink(receiveValue: { [weak self] in
                self?.usernameTextField.backgroundColor = $0
            })
            .store(in: &subscriptions)

        viewModel.validFields(usernameTextField.textPublisher,
                              password: passwordTextField.textPublisher)
            .sink(receiveValue: { [weak self] in
                self?.loginButton.isHidden = $0
            })
            .store(in: &subscriptions)

        loginButton.tapPublisher.sink { [weak self] (_) in
            guard let self = self else { return }
            self.delegate?.viewController(self, didPerformAction: .login)
        }
        .store(in: &subscriptions)
    }

    deinit {
        subscriptions.forEach {
            $0.cancel()
        }
        subscriptions.removeAll()
    }

}
