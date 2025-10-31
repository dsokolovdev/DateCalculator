//
//  LeapYear.swift
//  DateCalculator
//
//  Created by Dmitri on 21.10.25.
//
//  Description:
//  Provides a simple model describing whether a given year is a leap or common year,
//  including visual representation (SF Symbol and color) for UI display.
//

import UIKit

// MARK: - Leap Year Model
/// Represents whether a given year is leap or common,
/// with corresponding display color and SF Symbol.
struct LeapYear {
    
    // MARK: - Year Type
    /// Two possible types of years: Leap or Common.
    enum YearType: String {
        case leapYear = "Leap Year"
        case commonYear = "Common Year"
        
        /// Human-readable name used for display.
        var name: String { rawValue }
    }
    
    // MARK: - Properties
    /// Title shown in UI ("Year").
    var title: String { "Year" }
    
    /// SF Symbol name for display (e.g. `"sparkles"`).
    var symbol: String { "sparkles" }
    
    /// UI color used to visually indicate leap or common year.
    var color: UIColor
    
    /// Type of year — either `.leapYear` or `.commonYear`.
    var type: YearType
    
    // MARK: - Init
    /// Initializes a LeapYear instance based on leap-year status.
    ///
    /// - Parameter isLeap: Boolean value indicating if the year is leap.
    init(isLeap: Bool) {
        self.type = isLeap ? .leapYear : .commonYear
        self.color = isLeap ? .systemYellow : UIColor.secondaryLabel.withAlphaComponent(0.2)
    }
}
