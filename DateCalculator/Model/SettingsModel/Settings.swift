//
//  Settings.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 21.10.2025.
//
//  Description:
//  Defines the data structures and protocols used by the Settings screen.
//  Includes models for switches, buttons, sections, and the global Settings configuration.
//

import Foundation

// MARK: - Protocols
/// A base protocol for all setting items.
/// Each item must have a `name` used as an identifier or display label.
protocol SettingsProtocol {
    var name: String { get }
}

/// Delegate protocol for handling global actions such as resetting all settings.
protocol SettingsActionDeleagate: AnyObject {
    func resetToDefaults()
}

// MARK: - Settings Data Structure
/// Represents the complete configuration of the Settings screen,
/// including sections and an optional footer text.
struct Settings {
    /// The title displayed at the top of the Settings screen.
    static var title: String = K.Titles.settingsScreenName
    
    /// The grouped sections containing all settings.
    var sections: [SettingsSection]
    
    /// Optional footer text displayed at the bottom of the table.
    var footerText: String?
}

/// Represents a single section inside the Settings screen.
/// A section contains a title and one or more setting items.
struct SettingsSection {
    /// The title of the section, displayed as a header.
    var title: String
    
    /// The list of setting items contained in this section.
    var items: [SettingsProtocol]
}

// MARK: - Switch Item

/// Represents a switch-type setting (e.g., a toggle for enabling/disabling features).
struct SwitchItem: SettingsProtocol {
    /// The display name of the switch.
    let name: String
    
    /// The current ON/OFF state.
    var isOn: Bool
    
    /// The default state (used for Reset to Defaults).
    let defaultState: Bool
    
    /// Resets the switch to its default value.
    mutating func reset() {
        isOn = defaultState
    }
}

// MARK: - Button Item
/// Represents a button-type setting (e.g., “Reset to Defaults”).
struct ButtonItem: SettingsProtocol {
    /// The display name of the button.
    let name: String
    
    /// The text shown on the button itself.
    let buttonTitle: String
    
    /// Whether the button is currently enabled or disabled.
    var isEnabled: Bool 
    
    /// Delegate responsible for performing the associated action.
    var delegate: SettingsActionDeleagate?
    
    /// Changes the button's active state.
    mutating func changeButtonState(to newValue: Bool) {
        isEnabled = newValue
    }
    
    /// Triggers the assigned delegate method when the button is tapped.
    func tap() {
        guard isEnabled else { return }
        delegate?.resetToDefaults()
    }
}
