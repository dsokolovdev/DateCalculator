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

// MARK: - Base Protocols
/// A base protocol for all settings items.
/// Each item must have a `name` used as an identifier or display label.
protocol SettingsProtocol {
    var name: String { get }
}

/// Delegate protocol for handling global settings actions,
/// such as resetting all settings to default values.
protocol SettingsActionDeleagate: AnyObject {
    func resetToDefaults()
}

// MARK: - Settings Configuration
/// Represents the complete configuration of the Settings screen,
/// including all sections and optional footer text.
struct Settings {
    
    /// The title displayed at the top of the Settings screen.
    static var title: String = K.Titles.settingsScreenName
    
    /// The grouped sections containing all settings.
    var sections: [SettingsSection]
    
    /// Optional footer text displayed at the bottom of the Settings table.
    var footerText: String?
}

// MARK: - Section
/// Represents a logical group of settings displayed under one header.
/// Each section contains a title and a list of settings items.
struct SettingsSection {
    
    /// The title of the section, displayed as a header in the table.
    var title: String
    
    /// The list of items contained within this section.
    var items: [SettingsProtocol]
}

// MARK: - Switch Item
/// Represents a toggle-type setting, such as a feature enable/disable option.
struct SwitchItem: SettingsProtocol {
    
    /// The display name of the switch item.
    let name: String
    
    /// The current ON/OFF state.
    var isOn: Bool
    
    /// The default state (used for the Reset to Defaults action).
    let defaultState: Bool
    
    /// Resets the switch to its default value.
    mutating func reset() {
        isOn = defaultState
    }
}

// MARK: - Button Item
/// Represents a button-type setting, such as “Reset to Defaults”.
struct ButtonItem: SettingsProtocol {
    
    /// The display name of the button.
    let name: String
    
    /// The text shown on the button itself.
    let buttonTitle: String
    
    /// Whether the button is currently enabled or disabled.
    var isEnabled: Bool
    
    /// Delegate responsible for handling the button’s action.
    var delegate: SettingsActionDeleagate?
    
    /// Updates the button’s enabled/disabled state.
    mutating func changeButtonState(to newValue: Bool) {
        isEnabled = newValue
    }
    
    /// Triggers the assigned delegate method when the button is tapped.
    func tap() {
        guard isEnabled else { return }
        delegate?.resetToDefaults()
    }
}
