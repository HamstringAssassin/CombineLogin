//
//  ControlSubscription.swift
//  CombineLogin
//
//  Created by Al O'Connor on 4/4/21.
//

import Foundation
import Combine
import UIKit

final class ControlSubscription<S: Subscriber,
                                Control: UIControl,
                                Value>: Subscription where S.Input == Value {

    // MARK: - Properties
    private var subscriber: S?
    private var didEmitInitialValue: Bool
    private let keyPath: KeyPath<Control, Value>
    private let event: Control.Event
    private weak var control: Control?

    // MARK: - Subscription
    func request(_ demand: Subscribers.Demand) {
        if !didEmitInitialValue && demand > .none,
           let control = control {
            let _ = subscriber?.receive(control[keyPath: keyPath])
            didEmitInitialValue = true
        }
    }

    func cancel() {
        control?.removeTarget(self,
                              action: #selector(handleEvent),
                              for: event)
        subscriber = nil
    }

    // MARK: - Intialization
    internal init(
        subscriber: S?,
        didEmitInitialValue: Bool = true,
        keyPath: KeyPath<Control, Value>,
        event: UIControl.Event,
        control: Control?
    ) {
        self.subscriber = subscriber
        self.didEmitInitialValue = didEmitInitialValue
        self.keyPath = keyPath
        self.event = event
        self.control = control
        control?.addTarget(self,
                           action: #selector(handleEvent),
                           for: event)
    }

    @objc
    private func handleEvent() {
        guard let control = control else { return }
        let _ = subscriber?.receive(control[keyPath: keyPath])
    }
}
