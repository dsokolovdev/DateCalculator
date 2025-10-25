//
//  DatePickerManager.swift
//  DateCalculator
//
//  Created by Dmitri  on 18.10.25.
//

import Foundation
import UIKit

/// Протокол для уведомления контроллера об изменении даты
protocol DatePickerUpdatable: AnyObject {
    func didChangeDate(_ date: Date, for type: DateCalculatorViewModel.DateType)
    func updateHoroscopes(western: WesternHoroscope, chinese: ChineseHoroscope)
    func updateNavigationButtons(isBackButtonEnabled: Bool,
                                 isForwardButtonEnabled: Bool,
                                 isTodayButtonEnabled: Bool,
                                 isSwapButtonEnabled: Bool)
}

protocol SegmentsUpdatable: AnyObject {
    func updateSegments(_ segmetns: [String])
    //func updateValuesView(_ labels: [String])
}

/// Управляет моделью выбора дат и взаимодействием с UI
final class DateCalculatorViewModel {

    
    weak var delegate: DatePickerUpdatable? //уведомляет контроллер об изменнении дат
    weak var segmentsDelegate: SegmentsUpdatable? //уведомляет контроллер об изменнении количества сегментов в periodSegmentedControl
    
    private(set) var model = DateCalculatorModel()
    let settingsModel: SettingsModel
    private(set) var visibleSegments: [String]
    //private(set) var visibleRowLables: [String]
    
    init(settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
        self.visibleSegments = settingsModel.visibleSegments
        //self.visibleRowLables = settingsModel.visibleRowLables
        self.settingsModel.delegate = self
    }
    
    
    enum DateType {
        case from
        case to
    }
    
    // MARK: - Handle Picker Change
    func handleDateChange(_ date: Date, for type: DateType) {
        switch type {
        case .from:
            model.fromDates.updateSelectedDate(date, triggeredByUser: true)
            delegate?.didChangeDate(model.fromDates.selectedDate, for: .from)
            updateHoroscopes(for: model.fromDates.selectedDate)
        case .to:
            model.toDates.updateSelectedDate(date, triggeredByUser: true)
            delegate?.didChangeDate(model.toDates.selectedDate, for: .to)
            updateHoroscopes(for: model.toDates.selectedDate)
        }
        
        updateButtonsState(for: type)
        model.log(model.fullDebugInfo)
    }
    
    // MARK: - Navigation
    func goBack(for type: DateType) {
        if let date = (type == .from) ? model.fromDates.goBack() : model.toDates.goBack() {
            delegate?.didChangeDate(date, for: type)
            updateHoroscopes(for: date)
        }
        
        updateButtonsState(for: type)
        model.log(model.fullDebugInfo)
    }
    
    func goForward(for type: DateType) {
        if let date = (type == .from) ? model.fromDates.goForward() : model.toDates.goForward() {
            delegate?.didChangeDate(date, for: type)
            updateHoroscopes(for: date)
        }
        updateButtonsState(for: type)
        model.log(model.fullDebugInfo)
    }
    
    func goToToday(for type: DateType) {
        let date = (type == .from) ? model.fromDates.goToToday() : model.toDates.goToToday()
        delegate?.didChangeDate(date, for: type)
        updateHoroscopes(for: date)
        
        updateButtonsState(for: type)
        model.log(model.fullDebugInfo)
    }
    
    func swapDates(for type: DateType) {
        model.swapDates()
        
        delegate?.didChangeDate(model.fromDates.selectedDate, for: .from)
        delegate?.didChangeDate(model.toDates.selectedDate, for: .to)
        
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
        
        delegate?.updateNavigationButtons(isBackButtonEnabled: isBackEnabled,
                                          isForwardButtonEnabled: isForwardEnabled,
                                          isTodayButtonEnabled: isTodayEnabled,
                                          isSwapButtonEnabled: isSwapEnbabled
        )
    }
    
    private func updateHoroscopes(for date: Date) {
        let (western, chinese) = getHoroscopes(for: date)
        delegate?.updateHoroscopes(western: western, chinese: chinese)
    }
}

extension DateCalculatorViewModel: SettingsDelegate {
    func settingsDidUpdate(_ settings: SettingsModel) {
        visibleSegments = settings.visibleSegments
        segmentsDelegate?.updateSegments(visibleSegments)
        //segmentsDelegate?.updateValuesView(visibleRowLables)
    }
    
}

//extension DateCalculatorViewModel {
//    
//    enum viewMode {
//        case full
//        case yearMonthDay
//        case yearWeekDay
//        case yearDay
//        
////        enum selectedSegment {
////            case year
////            case month
////            case week
////            case day
////        }
//        
//        func getValues(selectedSegment: Int, selectedDate: Date, toDate: Date) -> DateComponents {
//            switch self {
//            case .full:
//                switch selectedSegment {
//                    case 0: return selectedDate.getDifference(to: toDate, components: .yearComponents)
//                    case 1: return selectedDate.getDifference(to: toDate, components: .monthComponents)
//                    case 2: return selectedDate.getDifference(to: toDate, components: .weekComponents)
//                    case 3: return selectedDate.getDifference(to: toDate, components: .dayComponents)
//                }
//            case .yearMonthDay
//                
//                return [currentDateType.getDifference(to: .now, components: .yearComponents)]
//            case .yearMonthDay:
//                return [currentDateType.getDifference(to: .now, components: .yearComponents),
//                        currentDateType.getDifference(to: .now, components: .monthComponents),
//            }
//        }
//        
//        
//        func currentViewMode () {
//            switch self {
//            case .full: return .yearDay
//            case 3:
//                let isMonth = self == "Month"
//                return isMonth ? .yearMonthDay : .yearWeekDay
//            default: return .full
//                
//            }
//        }
//        
//    }
//    
//    
//}

//func updateRowLabelsValues() {
//        let segment = periodSegmentedControl.selectedSegmentIndex
//        let valueseArray = viewModel.viewMode.getValues(selectedSegment: segment, currentDateType: currentDateType)
//        for index in valueLabels {
//            valueLabels[index] = valueseArray[index]
//        }
