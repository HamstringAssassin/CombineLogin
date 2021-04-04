//
//  Combine+ControlProperty.swift
//  CombineLogin
//
//  Created by Al O'Connor on 3/28/21.
//

import Foundation
import Combine
import UIKit

struct ControlPublisher<Control: UIControl, Value>: Publisher {
    // MARK: - Publisher
    func receive<S>(subscriber: S) where S: Subscriber,
                                         Self.Failure == S.Failure,
                                         Self.Output == S.Input {
        let subscription = ControlSubscription(subscriber: subscriber,
                                               keyPath: keyPath,
                                               event: controlEvents,
                                               control: control)
        subscriber.receive(subscription: subscription)
    }

    typealias Output = Value
    typealias Failure = Never

    // MARK: - properties
    let control: Control
    let controlEvents: Control.Event
    let keyPath: KeyPath<Control, Value>

    // MARK: - Initialization
    init(_ control: Control,
         controlEvents: Control.Event,
         keyPath: KeyPath<Control, Value>) {
        self.control = control
        self.controlEvents = controlEvents
        self.keyPath = keyPath
    }
}
