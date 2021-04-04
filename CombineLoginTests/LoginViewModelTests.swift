//
//  LoginViewModelTests.swift
//  CombineLoginTests
//
//  Created by Al O'Connor on 4/2/21.
//

import XCTest
import Combine
@testable import CombineLogin

class LoginViewModelTests: XCTestCase {

    private var subscriptions = Set<AnyCancellable>()

    override func tearDown() {
        subscriptions.forEach {
            $0.cancel()
        }
        subscriptions.removeAll()
    }

    func testValidUsernameWithThreeLetters() {
        // given
        let value = "123"
        let valuePublisher = CurrentValueSubject<String?, Never>(value).eraseToAnyPublisher()

        // when
        LoginViewModel().validUsername(valuePublisher)
            .sink(receiveValue: {
                // then
                XCTAssertEqual($0, false)
            })
            .store(in: &subscriptions)
    }

    func testValidUsernameWithFourLetters() {
        // given
        let value = "1234"
        let valuePublisher = CurrentValueSubject<String?, Never>(value).eraseToAnyPublisher()

        // when
        LoginViewModel().validUsername(valuePublisher)
            .sink(receiveValue: {
                XCTAssertEqual($0, true)
            })
            .store(in: &subscriptions)

        // then
    }

}
