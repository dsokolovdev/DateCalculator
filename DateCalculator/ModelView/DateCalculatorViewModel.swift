//
//  DatePickerManager.swift
//  DateCalculator
//
//  Created by Dmitri  on 18.10.25.
//

import Foundation
import UIKit

//MARK: - Protocols
/// Протокол для уведомления контроллера об изменении даты
protocol DatePickerUpdatable: AnyObject {
    func didChangeDate(_ date: Date, for type: DateCalculatorViewModel.DateType)
    func updateHoroscopes(for date: Date, western: WesternHoroscope, chinese: ChineseHoroscope)
    func updateNavigationButtons(isBackButtonEnabled: Bool,
                                 isForwardButtonEnabled: Bool,
                                 isTodayButtonEnabled: Bool,
                                 isSwapButtonEnabled: Bool)
}

protocol SegmentsUpdatable: AnyObject {
    func updateSegments(_ segmetns: [String])
    //func updateValuesView(_ labels: [String])
}

//Notify ValuesView about changes in segments and dates
protocol ValuesViewUpdatable: AnyObject {
    func updateValues(segments: [String], selectedIndex: Int, from start: Date, to end: Date)
}


//Notify DateCalculatorViewController to annimate elements
//protocol Animational: AnyObject {
//    func animateValueLabelsChange()
//    func animateDateButtonsChange()
//    func animateViewCardsChange()
//}

//MARK: - DateCalculator View Model
/// Управляет моделью выбора дат и взаимодействием с UI
final class DateCalculatorViewModel {
    
    weak var datePickerDelegate: DatePickerUpdatable? //уведомляет контроллер об изменнении дат
    weak var segmentsDelegate: SegmentsUpdatable? //уведомляет контроллер об изменнении количества сегментов в periodSegmentedControl
    weak var valuesDelegate: ValuesViewUpdatable? //
    //weak var animationDelegate: Animational?
    
    
    let settingsModel: SettingsModel
    
    private(set) var model = DateCalculatorModel()
    private(set) var visibleSegments: [String]
    
    var currentSegmentIndex: Int = 0
    
    init(settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
        self.visibleSegments = settingsModel.visibleSegments
        self.settingsModel.delegate = self
    }
    
    
    enum DateType {
        case from
        case to
    }
    
    // MARK: - Handle DatePicker Change
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
        //animateViewControllerChanges()
        model.log(model.fullDebugInfo)
        
    }
    
    // MARK: - Navigation
    func goBack(for type: DateType) {
        if let date = (type == .from) ? model.fromDates.goBack() : model.toDates.goBack() {
            datePickerDelegate?.didChangeDate(date, for: type)
            updateHoroscopes(for: date)
        }
        
        
        notifyValuesDelegate()
        updateButtonsState(for: type)
        //animateViewControllerChanges()
        model.log(model.fullDebugInfo)
    }
    
    func goForward(for type: DateType) {
        if let date = (type == .from) ? model.fromDates.goForward() : model.toDates.goForward() {
            datePickerDelegate?.didChangeDate(date, for: type)
            updateHoroscopes(for: date)
        }
        
        notifyValuesDelegate()
        updateButtonsState(for: type)
        //animateViewControllerChanges()
        model.log(model.fullDebugInfo)
    }
    
    func goToToday(for type: DateType) {
        let date = (type == .from) ? model.fromDates.goToToday() : model.toDates.goToToday()
        datePickerDelegate?.didChangeDate(date, for: type)
        updateHoroscopes(for: date)
        
        notifyValuesDelegate()
        updateButtonsState(for: type)
        //animateViewControllerChanges()
        model.log(model.fullDebugInfo)
    }
    
    func swapDates(for type: DateType) {
        model.swapDates()
        //animateViewControllerChanges()
        datePickerDelegate?.didChangeDate(model.fromDates.selectedDate, for: .from)
        datePickerDelegate?.didChangeDate(model.toDates.selectedDate, for: .to)
        
        let activeDate = (type == .from) ? model.fromDates.selectedDate : model.toDates.selectedDate
        updateHoroscopes(for: activeDate)
        
        notifyValuesDelegate()
        updateButtonsState(for: type)
        
        model.log(model.fullDebugInfo)
    }
    
    func getDates() -> (from: Date, to: Date) {
        (model.fromDates.selectedDate, model.toDates.selectedDate)
    }
    
    // MARK: - Гороскопы
    func getHoroscopes(for date: Date) -> (western: WesternHoroscope, chinese: ChineseHoroscope) {
        model.getHoroscopes(for: date)
    }
    
    // MARK: - Update UI Elements
    private func updateButtonsState(for type: DateType) {
        let dates = type == .from ? model.fromDates : model.toDates
        let isBackEnabled = dates.currentIndex > 0
        let isForwardEnabled = dates.currentIndex < dates.history.count - 1
        let isTodayEnabled = !dates.isToday
        let isSwapEnbabled = (model.fromDates != model.toDates)
        
        print("🧩 updateButtonsState called for \(type)")
        print("dates.history.count = \(dates.history.count)")
        print("dates.currentIndex = \(dates.currentIndex)")
        print("dates.selectedDate = \(dates.selectedDate)")
        
        datePickerDelegate?.updateNavigationButtons(isBackButtonEnabled: isBackEnabled,
                                          isForwardButtonEnabled: isForwardEnabled,
                                          isTodayButtonEnabled: isTodayEnabled,
                                          isSwapButtonEnabled: isSwapEnbabled
        )
    }
    
    private func updateHoroscopes(for date: Date) {
        let (western, chinese) = getHoroscopes(for: date)
        datePickerDelegate?.updateHoroscopes(for: date, western: western, chinese: chinese)
    }
    
    func notifyValuesDelegate() {
        let (from, to) = getDates()
        valuesDelegate?.updateValues(segments: visibleSegments, selectedIndex: currentSegmentIndex, from: from, to: to)
    }
    
//    func animateViewControllerChanges() {
//        animationDelegate?.animateDateButtonsChange()
//        animationDelegate?.animateValueLabelsChange()
//    }
}

//MARK: - Delegate
extension DateCalculatorViewModel: SettingsDelegate {
    func settingsDidUpdate(_ settings: SettingsModel) {
        visibleSegments = settings.visibleSegments
        segmentsDelegate?.updateSegments(visibleSegments)
        //notifyValuesDelegate()
    }
    
}
