//
//  SettingsTableViewController.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 2025.
//
//  Description:
//  Displays and manages the Settings screen of the app.
//  Provides options for toggling features, resetting to defaults,
//  and showing the app’s information footer.
//

import UIKit

/// A table view controller that manages all settings items,
/// including switches, reset button, and footer display.
final class SettingsTableViewController: UITableViewController{
    // MARK: - Initialization
    private let settingsModel: SettingsModel
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    init(settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
        super.init(style: .insetGrouped)
    }
    
    /// Initializes the controller using an insetGrouped style to match system Settings UI.
    //    init() {
    //        super.init(style: .insetGrouped)
    //    }
    
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
        
        // 🔧 Отключаем эффект прокрутки / растяжения
        tableView.bounces = false
    }
    
    /// Ensures the footer maintains a fixed height when the layout updates.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableFooterView?.frame.size.height = 120
    }
}

//MARK: - Delegate
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            let button = UIButton(type: .system)
            button.setTitle(buttonItem.buttonTitle, for: .normal)
            button.tag = indexPath.section * 100 + indexPath.row
            button.isEnabled = buttonItem.isEnabled
            button.alpha = buttonItem.isEnabled ? 1.0 : 0.5
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.contentHorizontalAlignment = .right
            button.sizeToFit()
            //button.frame = CGRect(x: 0, y: 0, width: 130, height: 34)
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40 // Adds more space between sections
    }
}

// MARK: - UI Setup
extension SettingsTableViewController {
    
    /// Configures and attaches a custom footer view at the bottom of the table.
    private func configureFooter() {
        let footerLabel = UILabel()
        footerLabel.text = SettingsModel.settingsFooterText
        footerLabel.font = .systemFont(ofSize: 13)
        footerLabel.textColor = .secondaryLabel
        footerLabel.textAlignment = .center
        footerLabel.numberOfLines = 0
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let footerView = UIView()
        footerView.addSubview(footerLabel)
        
        NSLayoutConstraint.activate([
            footerLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            footerLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            footerLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            footerLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -8)
        ])
        
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 120)
        tableView.tableFooterView = footerView
    }
}

// MARK: - Actions
extension SettingsTableViewController {
    
    /// Handles changes to switch values.
    @objc func switchChanged(_ sender: UISwitch) {
        let sectionIndex = sender.tag / 100
        let rowIndex = sender.tag % 100
        let key = sections[sectionIndex].items[rowIndex].name
        
        settingsModel.updateSwitchState(for: key, to: sender.isOn)
        settingsModel.updateResetButtonState()
        
        // Reload only the section with the Reset button
        //tableView.reloadSections(IndexSet(integer: sections.count - 1), with: .none)
        if let buttonItem = sections.last?.items.first as? ButtonItem {
            // Обновляем состояние кнопки без reload — нужно для плавной анимации
                animateResetButtonState(enabled: buttonItem.isEnabled)
            }
    }
    
    /// Handles Reset button tap.
    @objc func buttonTapped(_ sender: UIButton) {
        impactFeedback.impactOccurred()
        let sectionIndex = sender.tag / 100
        let rowIndex = sender.tag % 100
        
        guard let buttonItem = sections[sectionIndex].items[rowIndex] as? ButtonItem else { return }
        buttonItem.tap() // delegate?.resetToDefaults()
    }
}

extension SettingsTableViewController {
    
    private func animateResetButtonState(enabled: Bool) {
        // Reset — всегда последняя секция, первая строка
        let indexPath = IndexPath(row: 0, section: sections.count - 1)

        // Берём живую кнопку с экрана
        guard let cell = tableView.cellForRow(at: indexPath),
              let button = cell.accessoryView as? UIButton else {
            return
        }

        UIView.transition(with: button,
                          duration: 0.25,
                          options: [.transitionCrossDissolve, .allowUserInteraction]) {
            button.isEnabled = enabled
            button.alpha = enabled ? 1.0 : 0.5
        }
    }
}
