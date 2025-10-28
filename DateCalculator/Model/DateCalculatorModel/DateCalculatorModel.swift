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
    struct Dates: Equatable {
        private(set) var selectedDate: Date
        private(set) var history: [Date]
        private(set) var currentIndex: Int
        
        init(startDate: Date = Date().startOfDay) {
            self.selectedDate = startDate
            self.history = [startDate]
            self.currentIndex = 0
        }
        
        //trigged when date changes occure
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
        mutating func goBack() -> Date? {
            guard currentIndex > 0 else { return nil }
            currentIndex -= 1
            selectedDate = history[currentIndex]
            return selectedDate
        }
        
        mutating func goForward() -> Date? {
            guard currentIndex < history.count - 1 else { return nil }
            currentIndex += 1
            selectedDate = history[currentIndex]
            return selectedDate
        }
        
        mutating func goToToday() -> Date {
            let today = Date().startOfDay
            updateSelectedDate(today, triggeredByUser: true)
            return today
        }
        
        var isToday: Bool {
            Calendar.current.isDateInToday(selectedDate)
        }
        
        static func == (lhs: Dates, rhs: Dates) -> Bool  {
            lhs.selectedDate == rhs.selectedDate
        }
        
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
    
    // MARK: - Two independent histories
    var fromDates = Dates()
    var toDates = Dates()
    
    // MARK: - Horoscope
    func getHoroscopes(for data: Date) -> (western: WesternHoroscope, chinese: ChineseHoroscope) {
        let western = WesternHoroscope.get(for: data)
        let chinese = ChineseHoroscope.get(for: data)
        
        return(western, chinese)
    }
    
    mutating func swapDates() {
        let fromDate = fromDates.selectedDate
        let toDate = toDates.selectedDate
        
        fromDates.updateSelectedDate(toDate, triggeredByUser: true)
        toDates.updateSelectedDate(fromDate, triggeredByUser: true)
    }
}

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


    
    
    
//    func getDateFromHistory(by index: Int) -> Date? {
//        guard history.indices.contains(index) else { return nil }
//        return history[index]
//    }
    
//    // MARK: - Western Horoscope
//    func getWesternHoroscope(for date: Date) -> WesternHoroscope {
//        WesternHoroscope.get(for: date)
//    }
//    
//    // MARK: - Chinese Horoscope
//    func getChineseHoroscope(for date: Date) -> ChineseHoroscope {
//        ChineseHoroscope.get(for: date)
//    }
//    
//    // MARK: - Combined Horoscope
//    func getHoroscopes(for date: Date) -> (western: WesternHoroscope, chinese: ChineseHoroscope) {
//        let western = getWesternHoroscope(for: date)
//        let chinese = getChineseHoroscope(for: date)
//        return (western, chinese)
//    }
