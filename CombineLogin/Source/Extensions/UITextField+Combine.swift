//
//  UITextField+Combine.swift
//  CombineLogin
//
//  Created by Al O'Connor on 3/28/21.
//

import Foundation
import Combine
import UIKit

extension UITextField {
    /// `UItextField` publisher for KeyPath `text` for events `.allEditingEvents` & `.valueChanged`
    var textPublisher: AnyPublisher<String?, Never> {
        ControlPublisher(self,
                         controlEvents: [.allEditingEvents, .valueChanged],
                         keyPath: \.text)
            .eraseToAnyPublisher()
    }
}

extension UIButton {
    /// `UIButton` tap publisher for event `.touchUpInside`
    var tapPublisher: AnyPublisher<Void, Never> {
        ControlEvent(control: self, events: .touchUpInside).eraseToAnyPublisher()
    }
}
