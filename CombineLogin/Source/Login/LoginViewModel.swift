//
//  LoginViewModel.swift
//  CombineLogin
//
//  Created by Al O'Connor on 3/26/21.
//

import Foundation
import UIKit
import Combine

struct LoginViewModel {
    func validFields(_ username: AnyPublisher<String?, Never>,
                     password: AnyPublisher<String?, Never>) -> AnyPublisher<Bool, Never> {
        validUsername(username)
            .combineLatest(validPassword(password))
            .map({ (validUsername, validPassword) in
                return !(validUsername && validPassword)
            })
            .eraseToAnyPublisher()
    }
    
    func validPassword(_ password: AnyPublisher<String?, Never>) -> AnyPublisher<Bool, Never> {
        password.map { isValidPassword($0) }
            .eraseToAnyPublisher()
    }
    
    private func isValidPassword(_ password: String?) -> Bool {
        guard let password = password else { return false }
        return password.count >= 8
    }
    
    func validUsername(_ username: AnyPublisher<String?, Never>) -> AnyPublisher<Bool, Never> {
        username.map { value in
            isValidUsername(value)
        }
        .eraseToAnyPublisher()
    }
    
    private func isValidUsername(_ username: String?) -> Bool {
        guard let username = username else { return false }
        return username.count > 3
    }
    
    func userNameTextFieldBackgroundColor(_ username: AnyPublisher<String?, Never>) -> AnyPublisher<UIColor, Never> {
        validUsername(username)
            .map { value in
                value ? UIColor.clear : UIColor.red.withAlphaComponent(0.3)
            }
            .eraseToAnyPublisher()
    }
    
    func passwordTextFieldBackgroundColor(_ password: AnyPublisher<String?, Never>) -> AnyPublisher<UIColor, Never> {
        validPassword(password)
            .map { value in
                value ? UIColor.clear : UIColor.red.withAlphaComponent(0.3)
            }
            .eraseToAnyPublisher()
    }
    
}
