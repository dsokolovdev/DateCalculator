//
//  Constants.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 2025.
//  Centralized constants for identifiers, keys, and static values.
//

import UIKit

/// A namespace containing all constant values used across the app.
struct K {
    
    // MARK: - Reuse Identifiers
    
    /// Cell identifier used for table view cells in the Settings screen.
    static let cellIdentifier = "Cell"
    
    // MARK: - Titles
    
    /// Common titles used in navigation bars or alerts.
    struct Titles {
        static let appName = "DaysBetween"
        static let settingsScreenName = "Settings"
    }
    
    // MARK: - UserDefaults Keys (future use)
    
    /// Keys used to store user preferences or switch states in UserDefaults.
    struct UserDefaultsKeys {
        static let monthSwitch = "Month"
        static let weeksSwitch = "Weeks"
    }
}

