//
//  Combine+ControlEvent.swift
//  CombineLogin
//
//  Created by Al O'Connor on 3/28/21.
//

import Foundation
import UIKit
import Combine

struct ControlEvent<Control: UIControl>: Publisher {
    // MARK: - Publisher
    typealias Output = Void
    typealias Failure = Never

    func receive<S>(subscriber: S) where S: Subscriber,
                                         Self.Failure == S.Failure,
                                         Self.Output == S.Input {
        let subscription = Subscription(subscriber: subscriber,
                                        control: control,
                                        event: events)
        subscriber.receive(subscription: subscription)
    }

    // MARK: - Properties
    private let control: Control
    private let events: Control.Event

    // MARK: - Intialization
    init(control: Control, events: Control.Event) {
        self.control = control
        self.events = events
    }
}

extension ControlEvent {
    private final class Subscription<S: Subscriber, control: UIControl>: Combine.Subscription where S.Input == Void {
        // MARK: - Properties
        private var subscriber: S?
        private let control: Control?

        // MARK: - initialization
        init(subscriber: S,
             control: Control,
             event: Control.Event) {
            self.subscriber = subscriber
            self.control = control
            control.addTarget(self,
                              action: #selector(handleEvent),
                              for: event)
        }

        // MARK: - Subscription
        func request(_ demand: Subscribers.Demand) {
            // nothing to implement here
        }

        func cancel() {
            subscriber = nil
        }

        @objc
        private func handleEvent() {
            let _ = subscriber?.receive()
        }
    }
}
