//
//  DateCalculatorModel.swift
//  DateCalculator
//
//  Created by Dmitry on 18.10.2025.

import Foundation

// MARK: - DateCalculator Model

/// Core model responsible for storing and managing date selections,
/// navigation history, and related computed data (e.g., horoscopes).
struct DateCalculatorModel {
    
    // MARK: - Debug Configuration
#if DEBUG
    let enableDebugLogs = true
#else
    let enableDebugLogs = false
#endif
    
    // MARK: - Nested Type: Dates
    
    /// Represents a single date context (e.g., "From" or "To") with navigation history.
    struct Dates {
        /// Currently selected date.
        private(set) var selectedDate: Date
        /// History of all user-selected or programmatically updated dates.
        private(set) var history: [Date]
        /// Index of the current selection in the history array.
        private(set) var currentIndex: Int
        
        /// Returns `true` if the selected date is today.
        var isToday: Bool {
            Calendar.current.isDateInToday(selectedDate)
        }
        
        /// Initializes the structure with a start date (default: today at midnight).
        init(startDate: Date = Date().startOfDay) {
            self.selectedDate = startDate
            self.history = [startDate]
            self.currentIndex = 0
        }
        
        // MARK: - Date Updates
        
        /// Updates the selected date and maintains navigation history.
        ///
        /// - Parameters:
        ///   - newDate: The new date to select.
        ///   - triggeredByUser: Indicates if the update was initiated by user interaction.
        mutating func updateSelectedDate(_ newDate: Date, triggeredByUser: Bool) {
            guard newDate != selectedDate else { return }
            
            // Case 1: history is empty
            if history.isEmpty {
                history.append(newDate)
                currentIndex = 0
                selectedDate = newDate
                return
            }
            
            // Case 2: user manually selects a date after navigating back
            if triggeredByUser && currentIndex < history.count - 1 {
                history.removeSubrange((currentIndex + 1)..<history.count)
            }
            
            // Append new date and update index
            history.append(newDate)
            currentIndex = history.count - 1
            selectedDate = newDate
            
            // Limit history to prevent excessive memory growth
            let maxHistoryLimit = 500
            if history.count > maxHistoryLimit {
                let overflow = history.count - maxHistoryLimit
                history.removeFirst(overflow)
                currentIndex = history.count - 1
                selectedDate = history[currentIndex]
            }
        }
        
        // MARK: - Navigation Actions
        
        /// Moves one step back in the date history.
        /// Triggered when the user taps the **Back** button.
        /// - Returns: The previous date, or `nil` if already at the first entry.
        mutating func goBack() -> Date? {
            guard currentIndex > 0 else { return nil }
            currentIndex -= 1
            selectedDate = history[currentIndex]
            return selectedDate
        }
        
        /// Moves one step forward in the date history.
        /// Triggered when the user taps the **Forward** button.
        /// - Returns: The next date, or `nil` if already at the latest entry.
        mutating func goForward() -> Date? {
            guard currentIndex < history.count - 1 else { return nil }
            currentIndex += 1
            selectedDate = history[currentIndex]
            return selectedDate
        }
        
        /// Resets the selection to today's date.
        /// Triggered when the user taps the **Today** button.
        /// - Returns: The new selected date (today).
        mutating func goToday() -> Date {
            let today = Date().startOfDay
            updateSelectedDate(today, triggeredByUser: true)
            return today
        }
        
        // MARK: - Debug Utilities
        
        /// Returns formatted debug information for the current date state.
        ///
        /// - Parameters:
        ///   - property: The property name (used for context in logs).
        ///   - function: The calling function name (default: `#function`).
        ///   - file: The file name where it was called (default: `#fileID`).
        ///   - line: Line number of the call (default: `#line`).
        ///
        /// - Returns: A formatted string with detailed context info.
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
    
    // MARK: - Model Properties
    
    /// Represents the "From" date context.
    var fromDates = Dates()
    /// Represents the "To" date context.
    var toDates = Dates()
    
    // MARK: - Horoscope Logic
    
    /// Fetches both Western and Chinese horoscopes for a given date.
    ///
    /// - Parameter data: The date for which to calculate horoscopes.
    /// - Returns: A tuple containing `(western, chinese)` horoscope types.
    func getHoroscopes(for data: Date) -> (western: WesternHoroscope, chinese: ChineseHoroscope) {
        let western = WesternHoroscope.get(for: data)
        let chinese = ChineseHoroscope.get(for: data)
        return (western, chinese)
    }
    
    // MARK: - Swap Logic
    
    /// Swaps the "From" and "To" dates.
    /// Triggered when the user taps the **Swap** button.
    mutating func swapDates() {
        let fromDate = fromDates.selectedDate
        let toDate = toDates.selectedDate
        
        fromDates.updateSelectedDate(toDate, triggeredByUser: true)
        toDates.updateSelectedDate(fromDate, triggeredByUser: true)
    }
}

// MARK: - Protocol Conformance

/// Enables equality comparison between `Dates` instances.
/// Used in `DCViewModel` to check whether `fromDate` and `toDate` match.
extension DateCalculatorModel.Dates: Equatable {
    static func == (lhs: DateCalculatorModel.Dates, rhs: DateCalculatorModel.Dates) -> Bool {
        lhs.selectedDate == rhs.selectedDate
    }
}

// MARK: - Debug Info

extension DateCalculatorModel {
    /// Returns a combined debug snapshot of both date histories.
    var fullDebugInfo: String {
        """
        🧭 MODEL DEBUG SNAPSHOT
        -----------------------
        \(fromDates.debugInfo(for: "fromDates"))
        
        \(toDates.debugInfo(for: "toDates"))
        -----------------------
        """
    }
    
    /// Prints a debug message to the console (only in DEBUG builds).
    func log(_ message: String) {
#if DEBUG
        if enableDebugLogs {
            print(message)
        }
#endif
    }
}
