//
//  Animated.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 28.10.2025.
//
//  Description:
//  Reusable animated UI components for smooth visual transitions.
//  Includes animated versions of UIBarButtonItem, UILabel, and UIButton.
//

import UIKit

// MARK: - Animated Bar Button Item
/// Provides smooth fade transitions for navigation bar button items
/// such as Start, End, Today, Back, Forward, and Swap buttons.
final class AnimatedBarButtonItem: UIBarButtonItem {
    
    /// Animates state changes when button is enabled/disabled.
    override var isEnabled: Bool {
        didSet {
            guard let view = self.value(forKey: "view") as? UIView else { return }
            UIView.transition(with: view,
                              duration: 0.25,
                              options: [.transitionCrossDissolve, .allowUserInteraction],
                              animations: { })
        }
    }
    
    /// Animates title updates for smooth label text change.
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

// MARK: - Animated Label
/// UILabel subclass with crossfade text transitions used in ValueView.
final class AnimatedLabel: UILabel {
    
    /// Applies a fade transition when the label text changes.
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

// MARK: - Animated Button
/// UIButton subclass with a fade animation when enabled/disabled.
/// Commonly used for the “Reset” button in SettingsViewController.
final class AnimatedButton: UIButton {
    
    /// Smoothly updates the button’s appearance when enabled/disabled.
    override var isEnabled: Bool {
        didSet {
            UIView.transition(with: self,
                              duration: 0.25,
                              options: [.transitionCrossDissolve, .allowUserInteraction],
                              animations: { })
        }
    }
}
