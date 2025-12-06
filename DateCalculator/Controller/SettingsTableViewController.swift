//
//  SettingsTableViewController.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 21.10.2025.
//
//  Description:
//  Displays and manages the Settings screen of the app.
//  Provides options for toggling features, resetting to defaults,
//  and showing the app’s information footer.
//

import UIKit

// MARK: - Settings Table View Controller
/// A table view controller that manages all settings items,
/// including switches, reset button, and footer display.
final class SettingsTableViewController: UITableViewController {
    
    // MARK: - Initialization
    private let settingsModel: SettingsModel
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    init(settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    /// Convenience accessor for settings sections.
    private var sections: [SettingsSection] {
        settingsModel.settings.sections
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Settings.title
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.cellIdentifier)
        
        // Assign delegate to the Reset button during initialization
        if var buttonItem = sections.last?.items.first as? ButtonItem {
            buttonItem.delegate = self
            settingsModel.updateButtonItem(buttonItem)
        }
        
        // Load persisted switch states and update Reset button availability
        settingsModel.loadSavedSwitchStates()
        settingsModel.updateResetButtonState()
        
        // Configure footer view
        configureFooter()
        
        // Disable overscroll/bounce effect
        tableView.bounces = false
    }
    
    /// Ensures the footer maintains a fixed height when the layout updates.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableFooterView?.frame.size.height = 120 * scaleFactor
    }
}

// MARK: - Settings Delegate
extension SettingsTableViewController: SettingsActionDeleagate {
    /// Called when the Reset to Defaults action is triggered via delegate.
    func resetToDefaults() {
        impactFeedback.impactOccurred()
        print("→ Reset to defaults triggered via delegate")
        settingsModel.resetToDefaults()
        settingsModel.updateResetButtonState()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SettingsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    /// Configures and returns each cell in the Settings table.
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = item.name
        cell.selectionStyle = .none
        
        // Add UISwitch for toggleable settings
        if let switchItem = item as? SwitchItem {
            let switchView = UISwitch()
            switchView.isOn = switchItem.isOn
            switchView.tag = indexPath.section * 100 + indexPath.row
            switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
            cell.accessoryView = switchView
            
            // Add UIButton for actions (e.g. Reset)
        } else if let buttonItem = item as? ButtonItem {
            let button = AnimatedButton(type: .system)
            button.setTitle(buttonItem.buttonTitle, for: .normal)
            button.tag = indexPath.section * 100 + indexPath.row
            button.isEnabled = buttonItem.isEnabled
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            button.titleLabel?.font = .systemFont(ofSize: 16 * scaleFactor, weight: .medium)
            button.contentHorizontalAlignment = .right
            button.sizeToFit()
            cell.accessoryView = button
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsTableViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    /// Adds more space between sections for better visual separation.
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40 * scaleFactor
    }
}

// MARK: - Footer Setup
extension SettingsTableViewController {
    
    /// Configures and attaches a custom footer view at the bottom of the table.
    private func configureFooter() {
        let footerLabel = UILabel()
        footerLabel.text = SettingsModel.settingsFooterText
        footerLabel.font = .systemFont(ofSize: 13 * scaleFactor)
        footerLabel.textColor = .secondaryLabel
        footerLabel.textAlignment = .center
        footerLabel.numberOfLines = 0
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let footerView = UIView()
        footerView.addSubview(footerLabel)
        
        NSLayoutConstraint.activate([
            footerLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16 * scaleFactor),
            footerLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16 * scaleFactor),
            footerLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8 * scaleFactor),
            footerLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -8 * scaleFactor)
        ])
        
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 120 * scaleFactor)
        tableView.tableFooterView = footerView
    }
}

// MARK: - Actions
extension SettingsTableViewController {
    
    /// Handles toggle switch value changes and updates the model.
    @objc private func switchChanged(_ sender: UISwitch) {
        let sectionIndex = sender.tag / 100
        let rowIndex = sender.tag % 100
        let key = sections[sectionIndex].items[rowIndex].name
        
        settingsModel.updateSwitchState(for: key, to: sender.isOn)
        settingsModel.updateResetButtonState()
        
        if let buttonItem = sections.last?.items.first as? ButtonItem {
            // Update reset button state smoothly (no reload)
            animateResetButtonState(enabled: buttonItem.isEnabled)
        }
    }
    
    /// Handles the Reset button tap event.
    @objc private func buttonTapped(_ sender: UIButton) {
        impactFeedback.impactOccurred()
        let sectionIndex = sender.tag / 100
        let rowIndex = sender.tag % 100
        
        guard let buttonItem = sections[sectionIndex].items[rowIndex] as? ButtonItem else { return }
        buttonItem.tap() // delegate?.resetToDefaults()
    }
}

// MARK: - Animations
extension SettingsTableViewController {
    
    /// Animates the Reset button enable/disable state.
    private func animateResetButtonState(enabled: Bool) {
        // Reset — always the last section, first row
        let indexPath = IndexPath(row: 0, section: sections.count - 1)
        
        // Access visible button directly from table cell
        guard let cell = tableView.cellForRow(at: indexPath),
              let button = cell.accessoryView as? UIButton else {
            return
        }
        
        button.isEnabled = enabled
    }
}
