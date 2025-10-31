//
//  Calendar+Extensions.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 21.10.2025.
//
//  Description:
//  Utility extensions providing convenient calendar calculations
//  such as month boundaries, date ranges, and weekday lookups.
//

import Foundation

// MARK: - Calendar Utilities
/// A collection of helper methods for working with `Calendar` and `Date` values.
extension Calendar {
    
    // MARK: - Month Calculations
    
    /// Returns the total number of days in the given month.
    func daysInMonth(for date: Date) -> Int {
        range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// Returns the first day of the month for the given date.
    func firstDayOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
    
    /// Returns the last day of the month for the given date.
    func lastDayOfMonth(for date: Date) -> Date {
        let firstDay = firstDayOfMonth(for: date)
        let offset = DateComponents(month: 1, day: -1)
        return self.date(byAdding: offset, to: firstDay) ?? date
    }
    
    // MARK: - Date Range and Comparison
    
    /// Returns the number of full days between two dates.
    func daysBetween(_ start: Date, _ end: Date) -> Int {
        let startOfStart = startOfDay(for: start)
        let startOfEnd = startOfDay(for: end)
        return dateComponents([.day], from: startOfStart, to: startOfEnd).day ?? 0
    }
    
    /// Returns `true` if the specified date falls on a weekend.
    func isWeekend(_ date: Date) -> Bool {
        isDateInWeekend(date)
    }
    
    /// Returns an array of all dates between two given dates (inclusive).
    func generateDates(between startDate: Date, and endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate.startOfDay
        
        while currentDate <= endDate.startOfDay {
            dates.append(currentDate)
            guard let next = date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = next
        }
        
        return dates
    }
    
    // MARK: - Weekday Helpers
    
    /// Returns the localized name of the weekday (e.g. `"Monday"`).
    func weekdayName(for date: Date, locale: Locale = .current) -> String {
        let index = component(.weekday, from: date)
        return weekdaySymbols[index - 1].capitalized(with: locale)
    }
}
