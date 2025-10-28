//
//  Animated.swift
//  DateCalculator
//
//  Created by Dmitri  on 28.10.25.
//

import UIKit

final class AnimatedBarButtonItem: UIBarButtonItem {
    override var isEnabled: Bool {
        didSet {
            guard let view = self.value(forKey: "view") as? UIView else { return }
            UIView.transition(with: view,
                              duration: 0.25,
                              options: [.transitionCrossDissolve, .allowUserInteraction]) {
                view.alpha = self.isEnabled ? 1.0 : 0.5
            }
        }
    }
    
    override var title: String? {
        didSet {
            guard let view = self.value(forKey: "view") as? UIView else { return }
            UIView.transition(with: view,
                              duration: 0.25,
                              options: [.transitionCrossDissolve, .allowUserInteraction],
                              animations: { })
        }
    }
}

final class AnimatedLabel: UILabel {
    override var text: String? {
        didSet {
            guard oldValue != text else { return }
            UIView.transition(with: self,
                              duration: 0.25,
                              options: [.transitionCrossDissolve, .allowUserInteraction],
                              animations: { })
        }
    }
}


final class AnimatedButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            UIView.transition(with: self,
                              duration: 0.25,
                              options: [.transitionCrossDissolve, .allowUserInteraction]) {
                self.alpha = self.isEnabled ? 1.0 : 0.0
            }
        }
    }
}
