//
//  Date+Extensions.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 21.10.2025.
//  Utility extensions for date calculations and formatting.
//

import Foundation

// MARK: - Day and Time Utilities
/// Common date properties and helpers for calendar-related calculations.
extension Date {
    
    /// Returns the start of the day (00:00:00) in the current calendar.
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// Returns `true` if the date is today.
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    /// Returns the month number within the year as a string (1–12).
    var monthOfYear: String {
        let month = Calendar.current.component(.month, from: self)
        return "\(month)"
    }
    
    /// Returns the week number within the year as a string.
    var weekOfYear: String {
        let week = Calendar.current.component(.weekOfYear, from: self)
        return "\(week)"
    }
    
    /// Returns the day number within the year as a string.
    var dayOfYear: String {
            let calendar = Calendar.current
            
            // iOS 18+: use native API
            if #available(iOS 18, *) {
                let day = calendar.component(.dayOfYear, from: self)
                return "\(day)"
            }
            
            // iOS 13–17: fallback
            let day = calendar.ordinality(of: .day, in: .year, for: self) ?? 0
            return "\(day)"
        }
    
    /// Returns the weekday index (1 = Sunday, 7 = Saturday).
    var dayOfWeek: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    /// Full name of the weekday (e.g. "Friday").
    var weekDayName: String {
        Calendar.current.weekdaySymbols[self.dayOfWeek - 1]
    }
    
    /// Short name of the weekday (e.g. "Fri").
    var shortWeekDayName: String {
        Calendar.current.shortWeekdaySymbols[self.dayOfWeek - 1]
    }
    
    /// Number of days in the current year.
    var daysInYear: String {
        let days = Calendar.current.range(of: .day, in: .year, for: self)?.count ?? 0
        return "\(days)"
    }
    
    /// Number of weeks in the current year.
    var weeksInYear: String {
        let weeks = Calendar.current.range(of: .weekOfYear, in: .year, for: self)?.count ?? 0
        return "\(weeks)"
    }
}

// MARK: - Leap Year Detection
/// Determines whether the current year is a leap year.
extension Date {
    
    /// Returns `true` if the year of the current date is a leap year.
    var isLeapYear: Bool {
        let year = Calendar.current.component(.year, from: self)
        guard let february = Calendar.current.date(from: DateComponents(year: year, month: 2)),
              let days = Calendar.current.range(of: .day, in: .month, for: february)
        else {
            return false
        }
        return days.count == 29
    }
}

// MARK: - Date Formatting Helpers
/// String formatting utilities for display and short keys.
extension Date {
    
    /// Returns a short numeric key in the format "MMdd" (e.g. `0415` for April 15).
    /// Useful for horoscope or seasonal range calculations.
    var mdKey: Int {
        Int(self.formatted(.iso8601.month().day().dateSeparator(.omitted))) ?? 0
    }
    
    /// Returns the date formatted as `"d MMM yyyy"` (e.g. `15 Oct 2025`).
    var readableFormat: String {
        Date.sharedFormatter.string(from: self)
    }
    
    /// Static cached formatter to avoid recreation overhead.
    private static let sharedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

// MARK: - Date Components Difference
/// Utility for computing differences between dates using pre-defined component sets.
extension Date {
    
    /// Predefined component combinations for flexible date differences.
    enum Components {
        case cYMWD, cYMD, cYWD, cMWD, cYD, cMD, cWD, cD
        
        /// The corresponding `Calendar.Component` set for each case.
        fileprivate var values: Set<Calendar.Component> {
            switch self {
            case .cYMWD: return [.year, .month, .weekOfMonth, .day]
            case .cYMD:  return [.year, .month, .day]
            case .cYWD:  return [.year, .weekOfYear, .day]
            case .cMWD:  return [.month, .weekOfMonth, .day]
            case .cYD:   return [.year, .day]
            case .cMD:   return [.month, .day]
            case .cWD:   return [.weekOfYear, .day]
            case .cD:    return [.day]
            }
        }
    }
    
    /// Returns a `DateComponents` difference between `self` and another date
    /// based on the selected component combination.
    func getDifference(to date: Date, components: Components) -> DateComponents {
        Calendar.current.dateComponents(components.values, from: self, to: date)
    }
}
