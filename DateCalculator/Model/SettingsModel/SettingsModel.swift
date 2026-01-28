//
//  SettingsModel.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 21.10.2025.
//
//  Description:
//  ViewModel responsible for managing Settings data and business logic.
//  Handles switch state changes, reset actions, persistence, and footer text generation.
//

import UIKit

// MARK: - Protocols
/// Notifies `DateCalculatorViewModel` when settings have been updated
/// (e.g., switch toggled or Reset button pressed).
protocol SettingsDelegate: AnyObject {
    func settingsDidUpdate(_ settings: SettingsModel)
}

// MARK: - Settings Model
/// The view model that manages all logic for the Settings screen.
/// Controls switch states, reset actions, and persistence using `UserDefaults`.
final class SettingsModel {
    
    // MARK: - Delegate
    weak var delegate: SettingsDelegate?
    
    // MARK: - Model Data
    private(set) var settings: Settings = Settings(
        sections: [
            SettingsSection(
                title: "Date Range Options",
                items: [
                    SwitchItem(name: "Month", isOn: true, defaultState: true),
                    SwitchItem(name: "Week", isOn: true, defaultState: true)
                ]
            ),
            SettingsSection(
                title: "Reset Settings",
                items: [
                    ButtonItem(name: "Reset to Defaults",
                               buttonTitle: "Reset",
                               isEnabled: false,
                               delegate: nil)
                ]
            )
        ]
    )
    
    // MARK: - Init
    init() {
        loadSavedSwitchStates()
        updateResetButtonState()
    }
    
    // MARK: - Static Footer
    /// A footer text displayed at the bottom of the Settings screen.
    /// Automatically includes the current app version and build number.
    static var settingsFooterText: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
        return """
        \(K.Titles.appName)
        Version: \(version) (\(build))
        Made with ❤️  by D.S.
        © 2026
        """
    }
    
    // MARK: - Accessors
    
    /// Convenience accessor for modifying sections internally.
    private var sections: [SettingsSection] {
        get { settings.sections }
        set { settings.sections = newValue }
    }
    
    /// Indicates whether the Reset button should be enabled.
    /// Returns `true` if at least one switch differs from its default state.
    var isResetButtonEnabled: Bool {
        for section in sections {
            for item in section.items {
                if let switchItem = item as? SwitchItem,
                   switchItem.isOn != switchItem.defaultState {
                    return true
                }
            }
        }
        return false
    }
    
    // MARK: - State Management
    
    /// Resets all switches to their default values and updates `UserDefaults`.
    func resetToDefaults() {
        for sectionIndex in 0..<sections.count {
            for itemIndex in 0..<sections[sectionIndex].items.count {
                if var switchItem = sections[sectionIndex].items[itemIndex] as? SwitchItem {
                    switchItem.reset()
                    sections[sectionIndex].items[itemIndex] = switchItem
                    UserDefaults.standard.set(switchItem.isOn, forKey: switchItem.name)
                }
            }
        }
    }
    
    /// Enables or disables the Reset button depending on switch states.
    func updateResetButtonState() {
        var shouldEnable = false
        
        for section in sections {
            for item in section.items {
                if let switchItem = item as? SwitchItem,
                   switchItem.isOn != switchItem.defaultState {
                    shouldEnable = true
                    break
                }
            }
        }
        
        if var buttonItem = sections.last?.items.first as? ButtonItem {
            buttonItem.changeButtonState(to: shouldEnable)
            sections[sections.count - 1].items[0] = buttonItem
        }
        
        delegate?.settingsDidUpdate(self)
    }
    
    /// Updates a specific switch state and persists it to `UserDefaults`.
    /// - Parameters:
    ///   - key: The name of the switch.
    ///   - isOn: The new ON/OFF state.
    func updateSwitchState(for key: String, to isOn: Bool) {
        for sectionIndex in 0..<sections.count {
            for itemIndex in 0..<sections[sectionIndex].items.count {
                if var switchItem = sections[sectionIndex].items[itemIndex] as? SwitchItem,
                   switchItem.name == key {
                    switchItem.isOn = isOn
                    sections[sectionIndex].items[itemIndex] = switchItem
                    UserDefaults.standard.set(isOn, forKey: key)
                }
            }
        }
        delegate?.settingsDidUpdate(self)
    }
    
    /// Loads saved switch states from `UserDefaults` and applies them to the model.
    func loadSavedSwitchStates() {
        for section in 0..<sections.count {
            for item in 0..<sections[section].items.count {
                if var switchItem = sections[section].items[item] as? SwitchItem {
                    if UserDefaults.standard.object(forKey: switchItem.name) != nil {
                        switchItem.isOn = UserDefaults.standard.bool(forKey: switchItem.name)
                        sections[section].items[item] = switchItem
                    }
                }
            }
        }
    }
    
    /// Replaces the existing Reset button with an updated instance.
    /// - Parameter buttonItem: The new button to apply.
    func updateButtonItem(_ buttonItem: ButtonItem) {
        guard !sections.isEmpty,
              !sections.last!.items.isEmpty else { return }
        
        sections[sections.count - 1].items[0] = buttonItem
    }
    
    /// Updates a specific button item inside the table view (by index path).
    func updateButtonItem(_ updatedItem: ButtonItem, at indexPath: IndexPath) {
        settings.sections[indexPath.section].items[indexPath.row] = updatedItem
    }
}

// MARK: - Computed Properties
extension SettingsModel {
    
    /// Returns a list of visible segments for the main screen based on active switches.
    /// Always includes `"Year"` and `"Day"`, optionally `"Month"` and `"Week"`.
    var visibleSegments: [String] {
        var segments: [String] = ["Year", "Day"]
        var isMonthOn = false
        
        // Month
        if let monthItem = sections
            .flatMap({ $0.items })
            .first(where: { ($0 as? SwitchItem)?.name == "Month" }) as? SwitchItem,
           monthItem.isOn {
            segments.insert("Month", at: 1)
            isMonthOn = true
        }
        print(segments)
        
        // Week
        if let weekItem = sections
            .flatMap({ $0.items })
            .first(where: { ($0 as? SwitchItem)?.name == "Week" }) as? SwitchItem,
           weekItem.isOn {
            segments.insert("Week", at: isMonthOn ? 2 : 1)
        }
        print(segments)
        return segments
    }
}
