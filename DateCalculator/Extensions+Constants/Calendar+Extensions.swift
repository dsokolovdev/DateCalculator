//
//  Calendar+Extensions.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 2025.
//  Utility extensions for convenient calendar calculations.
//

import Foundation

// MARK: - Calendar Utilities
extension Calendar {
    
    /// Returns the number of days in the given month of the given date.
    func daysInMonth(for date: Date) -> Int {
        guard let range = self.range(of: .day, in: .month, for: date) else { return 0 }
        return range.count
    }
    
    /// Returns the first day of the month for a given date.
    func firstDayOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
    
    /// Returns the last day of the month for a given date.
    func lastDayOfMonth(for date: Date) -> Date {
        let firstDay = firstDayOfMonth(for: date)
        let components = DateComponents(month: 1, day: -1)
        return self.date(byAdding: components, to: firstDay) ?? date
    }
    
    /// Returns the number of days between two dates.
    func daysBetween(_ start: Date, _ end: Date) -> Int {
        let startOfStart = self.startOfDay(for: start)
        let startOfEnd = self.startOfDay(for: end)
        let components = dateComponents([.day], from: startOfStart, to: startOfEnd)
        return components.day ?? 0
    }
    
    /// Returns `true` if the date is a weekend.
    func isWeekend(_ date: Date) -> Bool {
        return isDateInWeekend(date)
    }
    
    /// Returns the weekday name (e.g., "Monday").
    func weekdayName(for date: Date, locale: Locale = .current) -> String {
        let weekdayIndex = component(.weekday, from: date)
        return weekdaySymbols[weekdayIndex - 1].capitalized(with: locale)
    }

    /// Returns a list of all dates between two given dates (inclusive).
    func generateDates(between startDate: Date, and endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate.startOfDay
        while currentDate <= endDate.startOfDay {
            dates.append(currentDate)
            guard let nextDate = self.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        return dates
    }
}
