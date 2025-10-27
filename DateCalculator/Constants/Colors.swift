//
//  C.swift
//  DateCalculator
//
//  Created by Dmitri  on 27.10.25.
//

import UIKit

/// App color palette, supports light/dark mode dynamically.
struct C {
    /// Primary dynamic accent color
    static let mazarineBlue = UIColor { trait in
        if trait.userInterfaceStyle == .dark {
            return UIColor(red: 0.33, green: 0.74, blue: 0.97, alpha: 1.0)
        } else {
            return UIColor(red: 0.15, green: 0.24, blue: 0.46, alpha: 1.0)
        }
    }

    /// Secondary red accent for warnings or energy
    static let chiGong = UIColor { trait in
        if trait.userInterfaceStyle == .dark {
            return UIColor(red: 0.99, green: 0.24, blue: 0.24, alpha: 1.00)
        } else {
            return UIColor(red: 0.84, green: 0.19, blue: 0.19, alpha: 1.00)
        }
    }
}
