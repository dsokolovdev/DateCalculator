//
//  DatePickerManager.swift
//  DateCalculator
//
//  Created by Dmitry on 18.10.25.
//

import Foundation
import UIKit

// MARK: - Protocols

/// Notifies the controller when the date changes or when related UI elements must be updated.
protocol DatePickerUpdatable: AnyObject {
    /// Called when a date is changed in the picker or model.
    func didChangeDate(_ date: Date, for type: DateCalculatorViewModel.DateType)
    
    /// Updates the horoscope information for the selected date.
    func updateHoroscopes(for date: Date, western: WesternHoroscope, chinese: ChineseHoroscope)
    
    /// Updates the state (enabled/disabled) of navigation buttons.
    func updateNavigationButtons(isBackButtonEnabled: Bool,
                                 isForwardButtonEnabled: Bool,
                                 isTodayButtonEnabled: Bool,
                                 isSwapButtonEnabled: Bool)
}

/// Informs `DateCalculatorViewController` about segment count or label changes.
protocol SegmentsUpdatable: AnyObject {
    func updateSegments(_ segments: [String])
}

/// Notifies `ValuesView` about updates in segment selection and date range.
protocol ValuesViewUpdatable: AnyObject {
    func updateValues(segments: [String], selectedIndex: Int, from start: Date, to end: Date)
}

// MARK: - DateCalculator View Model

/// Acts as a ViewModel for the Date Calculator.
/// Coordinates the model (`DateCalculatorModel`) with UI delegates and manages user interactions.
final class DateCalculatorViewModel {
    
    // MARK: - Types
    
    /// Identifies which date context is being manipulated: `from` or `to`.
    enum DateType {
        case from
        case to
    }
    
    // MARK: - Delegates
    
    weak var datePickerDelegate: DatePickerUpdatable?   // Notifies controller about date or horoscope updates
    weak var segmentsDelegate: SegmentsUpdatable?       // Notifies controller about segment updates
    weak var valuesDelegate: ValuesViewUpdatable?       // Notifies values view about visible segment and date updates
    
    // MARK: - Properties
    
    let settingsModel: SettingsModel
    private(set) var model = DateCalculatorModel()
    private(set) var visibleSegments: [String]
    var currentSegmentIndex: Int = 0
    
    // MARK: - Initialization
    
    init(settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
        self.visibleSegments = settingsModel.visibleSegments
        self.settingsModel.delegate = self
    }
    
    // MARK: - Handle Date Picker Changes
    
    /// Called when a date is changed via the picker.
    /// Updates the model, horoscopes, and related UI components.
    func handleDateChange(_ date: Date, for type: DateType) {
        switch type {
        case .from:
            model.fromDates.updateSelectedDate(date, triggeredByUser: true)
            updateHoroscopes(for: model.fromDates.selectedDate)
            datePickerDelegate?.didChangeDate(model.fromDates.selectedDate, for: .from)
            
        case .to:
            model.toDates.updateSelectedDate(date, triggeredByUser: true)
            updateHoroscopes(for: model.toDates.selectedDate)
            datePickerDelegate?.didChangeDate(model.toDates.selectedDate, for: .to)
        }
        
        notifyValuesDelegate()
        updateButtonsState(for: type)
        model.log(model.fullDebugInfo)
    }
    
    // MARK: - Navigation
    
    /// Navigates one step backward in the date history.
    /// Triggered when the user taps the **Back** button.
    func goBack(for type: DateType) {
        if let date = (type == .from) ? model.fromDates.goBack() : model.toDates.goBack() {
            datePickerDelegate?.didChangeDate(date, for: type)
            updateHoroscopes(for: date)
        }
        
        notifyValuesDelegate()
        updateButtonsState(for: type)
        model.log(model.fullDebugInfo)
    }
    
    /// Navigates one step forward in the date history.
    /// Triggered when the user taps the **Forward** button.
    func goForward(for type: DateType) {
        if let date = (type == .from) ? model.fromDates.goForward() : model.toDates.goForward() {
            datePickerDelegate?.didChangeDate(date, for: type)
            updateHoroscopes(for: date)
        }
        
        notifyValuesDelegate()
        updateButtonsState(for: type)
        model.log(model.fullDebugInfo)
    }
    
    /// Sets the date to today’s date.
    /// Triggered when the user taps the **Today** button.
    func goToToday(for type: DateType) {
        let date = (type == .from) ? model.fromDates.goToday() : model.toDates.goToday()
        datePickerDelegate?.didChangeDate(date, for: type)
        updateHoroscopes(for: date)
        
        notifyValuesDelegate()
        updateButtonsState(for: type)
        model.log(model.fullDebugInfo)
    }
    
    /// Swaps the “From” and “To” dates.
    /// Triggered when the user taps the **Swap** button.
    func swapDates(for type: DateType) {
        model.swapDates()
        
        datePickerDelegate?.didChangeDate(model.fromDates.selectedDate, for: .from)
        datePickerDelegate?.didChangeDate(model.toDates.selectedDate, for: .to)
        
        let activeDate = (type == .from) ? model.fromDates.selectedDate : model.toDates.selectedDate
        updateHoroscopes(for: activeDate)
        
        notifyValuesDelegate()
        updateButtonsState(for: type)
        model.log(model.fullDebugInfo)
    }
    
    /// Returns the current "From" and "To" dates.
    func getDates() -> (from: Date, to: Date) {
        (model.fromDates.selectedDate, model.toDates.selectedDate)
    }
    
    // MARK: - Horoscopes
    
    /// Returns horoscope data for a given date.
    func getHoroscopes(for date: Date) -> (western: WesternHoroscope, chinese: ChineseHoroscope) {
        model.getHoroscopes(for: date)
    }
    
    // MARK: - UI State Updates
    
    /// Updates the state of navigation buttons based on the current date history.
    private func updateButtonsState(for type: DateType) {
        let dates = (type == .from) ? model.fromDates : model.toDates
        let isBackEnabled = dates.currentIndex > 0
        let isForwardEnabled = dates.currentIndex < dates.history.count - 1
        let isTodayEnabled = !dates.isToday
        let isSwapEnabled = (model.fromDates != model.toDates)
        
        datePickerDelegate?.updateNavigationButtons(
            isBackButtonEnabled: isBackEnabled,
            isForwardButtonEnabled: isForwardEnabled,
            isTodayButtonEnabled: isTodayEnabled,
            isSwapButtonEnabled: isSwapEnabled
        )
    }
    
    /// Updates horoscope information in the UI.
    private func updateHoroscopes(for date: Date) {
        let (western, chinese) = getHoroscopes(for: date)
        datePickerDelegate?.updateHoroscopes(for: date, western: western, chinese: chinese)
    }
    
    /// Notifies the `ValuesView` about changes in segments or dates.
    func notifyValuesDelegate() {
        let (from, to) = getDates()
        valuesDelegate?.updateValues(segments: visibleSegments,
                                     selectedIndex: currentSegmentIndex,
                                     from: from,
                                     to: to)
    }
}

// MARK: - SettingsDelegate

/// Conforms to `SettingsDelegate` to receive updates from the Settings screen.
/// When the user changes visible segments, this updates the ViewModel state and informs the UI.
extension DateCalculatorViewModel: SettingsDelegate {
    func settingsDidUpdate(_ settings: SettingsModel) {
        visibleSegments = settings.visibleSegments
        segmentsDelegate?.updateSegments(visibleSegments)
    }
}
