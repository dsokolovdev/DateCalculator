//
//  Date+Extensions.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 2025.
//  Utility extensions for date calculations and formatting.
//

import Foundation

// MARK: - Day and Time Utilities
extension Date {
    
    /// Returns the start of the day (00:00:00) for the current date in the system calendar.
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// Returns `true` if the current date is today.
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    /// Returns a new date with the time set to midnight (00:00:00) in the same day.
//    func atMidnight() -> Date {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.year, .month, .day], from: self)
//        return calendar.date(from: components) ?? self
//    }
    
    var mothOfYear: String {
        let month = Calendar.current.component(.month, from: self)
        return "\(month)"
    }
    
    var weekOfYear: String {
        let week = Calendar.current.component(.weekOfYear, from: self)
        return "\(week)"
    }
    
    var dayOfYear: String {
        //let day = Calendar.current.ordinality(of: .dayOfYear, in: .year, for: self) ?? 0
        let day = Calendar.current.component(.dayOfYear, from: self)
        return "\(day)"
    }
    
    var dayOfWeek: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    /// Полное имя дня недели (например, "Friday")
    var weekDayName: String {
        let weekDay = Calendar.current.weekdaySymbols[self.dayOfWeek - 1]
        return "\(weekDay)"
    }
    
    /// Сокращённое имя дня недели (например, "Fri")
    var shortWeekDayName: String {
        Calendar.current.shortWeekdaySymbols[self.dayOfWeek - 1]
    }
    
    /// Количество дней в году
    var daysInYear: String {
        let daysInYear = Calendar.current.range(of: .day, in: .year, for: self)?.count ?? 0
        return "\(daysInYear)"
    }
    
    /// Количество недель в году
    var weeksInYear: String {
        let weeksInYear = Calendar.current.range(of: .weekOfYear, in: .year, for: self)?.count ?? 0
        return "\(weeksInYear)"
    }
    
    /// Количество месяцев в году
    var monthsInYear: String {
        let monthInYear = Calendar.current.range(of: .month, in: .year, for: self)?.count ?? 0
        return "\(monthInYear)"
    }
}

// MARK: - Leap Year Detection
extension Date {
    
    /// Returns `true` if the year of the current date is a leap year.
    var isLeapYear: Bool {
        let year = Calendar.current.component(.year, from: self)
        guard let february = Calendar.current.date(from: DateComponents(year: year, month: 2)),
              let days = Calendar.current.range(of: .day, in: .month, for: february) else {
            return false
        }
        return days.count == 29
    }
}

// MARK: - Date Formatting Helpers
extension Date {
    
    /// Returns a short key in the format "MMdd" (e.g. 0415 for April 15).
    /// Useful for horoscope or seasonal date ranges.
    var mdKey: Int {
        Int(self.formatted(.iso8601.month().day().dateSeparator(.omitted))) ?? 0
    }
    
    /// Returns a string formatted as "d MMM yyyy" (e.g. 15 Oct 2025).
    var readableFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: self)
    }
}

extension Date {
    
    enum Components {
        case eraComponents, yearComponents, monthComponents, weekComponents, dayComponents
        
        fileprivate var values: Set<Calendar.Component> {
            switch self {
            case .eraComponents: return [.era, .year, .month, .weekOfMonth, .day]
            case .yearComponents: return [.year, .month, .weekOfMonth, .day]
            case .monthComponents: return [.month, .weekOfMonth, .day]
            case .weekComponents: return [.weekOfYear, .day]
            case .dayComponents: return [.day]
            }
        }
    }
    
    func getDifference(to date: Date, components: Components) -> DateComponents {
        Calendar.current.dateComponents(components.values, from: self, to: date)
    }
}
