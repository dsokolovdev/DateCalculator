//
//  DateCalculatorModel.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 2025.
//

import Foundation

//MARK: - DateCalculator Model
/// Основная модель, которая хранит и управляет данными выбора дат.
struct DateCalculatorModel {
#if DEBUG
    let enableDebugLogs = true
#else
    let enableDebugLogs = false
#endif
    
    // MARK: - Nested Type
    struct Dates {
        private(set) var selectedDate: Date
        private(set) var history: [Date]
        private(set) var currentIndex: Int
        
        var isToday: Bool {
            Calendar.current.isDateInToday(selectedDate)
        }
        
        init(startDate: Date = Date().startOfDay) {
            self.selectedDate = startDate
            self.history = [startDate]
            self.currentIndex = 0
        }
        
        //Trigged when date has been changed
        mutating func updateSelectedDate(_ newDate: Date, triggeredByUser: Bool) {
            guard newDate != selectedDate else { return }
            
            //1 history is empty
            if history.isEmpty {
                history.append(newDate)
                currentIndex = 0
                selectedDate = newDate
                return
            }
            
            //2 manually selected date
            if triggeredByUser && currentIndex < history.count - 1 {
                history.removeSubrange((currentIndex + 1)..<history.count)
            }
            
            history.append(newDate)
            currentIndex = history.count - 1
            selectedDate = newDate
            
            //checking history limits
            let maxHistoryLimit = 500
            if history.count > maxHistoryLimit {
                let overflow = history.count - maxHistoryLimit
                history.removeFirst(overflow)
                currentIndex = history.count - 1
                selectedDate = history[currentIndex]
            }
        }
        
        //for navigation buttons: back forward today swap
        ///Trigged when backButton tapped
        ///DCViewController: @objc private func goBack()  -> DCViewModel: func goBack(for type: DateType) -> CURRENT: DateCalculatorModel: func goBack()
        mutating func goBack() -> Date? {
            guard currentIndex > 0 else { return nil }
            currentIndex -= 1
            selectedDate = history[currentIndex]
            return selectedDate
        }
        ///Trigged when forwardButton tapped
        ///DCViewController: @objc private func goForward()  -> DCViewModel: func goForward(for type: DateType) -> CURRENT: DateCalculatorModel: func goForward()
        mutating func goForward() -> Date? {
            guard currentIndex < history.count - 1 else { return nil }
            currentIndex += 1
            selectedDate = history[currentIndex]
            return selectedDate
        }
        ///Trigged when todayButton tapped
        ///DCViewController: @objc private func goToday()  -> DCViewModel: func goToday(for type: DateType) -> CURRENT: DateCalculatorModel: func goToday()
        mutating func goToday() -> Date {
            let today = Date().startOfDay
            updateSelectedDate(today, triggeredByUser: true)
            return today
        }
        
        ///Debug Info printed in debugger area
        func debugInfo(for property: String, _ function: String = #function, _ file: String = #fileID, _ line: Int = #line) -> String {
            let location = file.components(separatedBy: "/").last?.replacingOccurrences(of: ".swift", with: "") ?? "UnknownFile"
            return """
                [\(location).\(property)] → \(function) @ line \(line)
                Selected: \(selectedDate.readableFormat)
                Index: \(currentIndex)
                History: \(history.count), \(history)
                """
        }
    }
    
    //From and To date of type of above Struct Dates
    var fromDates = Dates()
    var toDates = Dates()
    
    // MARK: - Horoscope
    ///Get horoscopes data
    ///DCViewController: func updateHoroscopes(for date: Date, western: WesternHoroscope, chinese: ChineseHoroscope) -> DCViewModel: private func updateHoroscopes(for date: Date) -> func getHoroscopes(for date: Date) -> CURRENT: func getHoroscopes(for data: Date)
    func getHoroscopes(for data: Date) -> (western: WesternHoroscope, chinese: ChineseHoroscope) {
        let western = WesternHoroscope.get(for: data)
        let chinese = ChineseHoroscope.get(for: data)
        
        return(western, chinese)
    }
    
    ///Trigged when swapButton tapped
    ///DCViewController: @objc private func swapDates()  -> DCViewModel: func swapDates(for type: DateType)-> CURRENT:  mutating func swapDates()
    mutating func swapDates() {
        let fromDate = fromDates.selectedDate
        let toDate = toDates.selectedDate
        
        fromDates.updateSelectedDate(toDate, triggeredByUser: true)
        toDates.updateSelectedDate(fromDate, triggeredByUser: true)
    }
}

//MARK: - Protocol Conformance
//Fot comparisson of fromDate and toDates in DCViewModel: func updateButtonsState(for type: DateType)
extension DateCalculatorModel.Dates: Equatable {
    static func == (lhs: DateCalculatorModel.Dates, rhs: DateCalculatorModel.Dates) -> Bool  {
        lhs.selectedDate == rhs.selectedDate
    }
}

//MARK: - Debug Info
extension DateCalculatorModel {
    /// Возвращает краткую сводку состояния обеих историй
    var fullDebugInfo: String {
        """
        🧭 MODEL DEBUG SNAPSHOT
        -----------------------
        \(fromDates.debugInfo(for: "fromDates"))
        
        \(toDates.debugInfo(for: "toDates"))
        -----------------------
        """
    }
    
    func log(_ message: String) {
#if DEBUG
        if enableDebugLogs {
            print(message)
        }
#endif
    }
}
