//
//  WesternHoroscope.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 18.10.2025.
//
//  Description:
//  Provides a Western zodiac model that determines the Zodiac sign and Element
//  for a given date based on the Gregorian calendar.
//

import Foundation

// MARK: - Western Horoscope Structure
/// Represents a Western horoscope sign with its associated element and date range.
struct WesternHoroscope {
    
    // MARK: - Zodiac Signs
    /// The 12 Western zodiac signs, each associated with a date range.
    enum Zodiac: String, CaseIterable {
        case capricorn = "Capricorn"
        case aquarius = "Aquarius"
        case pisces = "Pisces"
        case aries = "Aries"
        case taurus = "Taurus"
        case gemini = "Gemini"
        case cancer = "Cancer"
        case leo = "Leo"
        case virgo = "Virgo"
        case libra = "Libra"
        case scorpio = "Scorpio"
        case sagittarius = "Sagittarius"
        
        /// Human-readable name.
        var name: String { rawValue }
        /// Section title used in UI.
        var title: String { "Western Zodiac" }
        
        /// Emoji icon representing the zodiac sign.
        var icon: String {
            switch self {
            case .capricorn: return "♑️"
            case .aquarius: return "♒️"
            case .pisces: return "♓️"
            case .aries: return "♈️"
            case .taurus: return "♉️"
            case .gemini: return "♊️"
            case .cancer: return "♋️"
            case .leo: return "♌️"
            case .virgo: return "♍️"
            case .libra: return "♎️"
            case .scorpio: return "♏️"
            case .sagittarius: return "♐️"
            }
        }
    }
    
    // MARK: - Elements
    /// The four classical elements associated with zodiac signs.
    enum Element: String {
        case air = "Air"
        case water = "Water"
        case fire = "Fire"
        case earth = "Earth"
        
        /// Human-readable name.
        var name: String { rawValue }
        /// Section title used in UI.
        var title: String { "Element" }
        
        /// Emoji icon representing the element.
        var icon: String {
            switch self {
            case .air: return "💨"
            case .water: return "💧"
            case .fire: return "🔥"
            case .earth: return "🌎"
            }
        }
    }
    
    // MARK: - Properties
    /// The zodiac sign (e.g. Aries, Virgo).
    let zodiac: Zodiac
    /// The associated element (Fire, Earth, Air, Water).
    let element: Element
    /// The inclusive date range (MMDD format) representing the sign's period.
    let range: ClosedRange<Int>
    
    // MARK: - All Signs
    /// Complete list of all 12 zodiac signs with their date ranges and elements.
    /// Uses a numeric `MMDD` key for simplified comparison.
    static let allCases: [WesternHoroscope] = [
        WesternHoroscope(zodiac: .capricorn,   element: .earth, range: 101...119),
        WesternHoroscope(zodiac: .aquarius,    element: .air,   range: 120...218),
        WesternHoroscope(zodiac: .pisces,      element: .water, range: 219...320),
        WesternHoroscope(zodiac: .aries,       element: .fire,  range: 321...419),
        WesternHoroscope(zodiac: .taurus,      element: .earth, range: 420...520),
        WesternHoroscope(zodiac: .gemini,      element: .air,   range: 521...621),
        WesternHoroscope(zodiac: .cancer,      element: .water, range: 622...722),
        WesternHoroscope(zodiac: .leo,         element: .fire,  range: 723...822),
        WesternHoroscope(zodiac: .virgo,       element: .earth, range: 823...922),
        WesternHoroscope(zodiac: .libra,       element: .air,   range: 923...1023),
        WesternHoroscope(zodiac: .scorpio,     element: .water, range: 1024...1121),
        WesternHoroscope(zodiac: .sagittarius, element: .fire,  range: 1122...1221),
        // Capricorn overlaps at year end.
        WesternHoroscope(zodiac: .capricorn,   element: .earth, range: 1222...1231)
    ]
    
    // MARK: - Lookup
    /// Determines the Western horoscope sign for a given date.
    ///
    /// - Parameter date: The date to evaluate.
    /// - Returns: The corresponding `WesternHoroscope` entry.
    ///
    /// The method uses a custom computed property `mdKey`
    /// (e.g. March 21 → 321) to perform quick range matching.
    static func get(for date: Date) -> WesternHoroscope {
        return allCases.first { $0.range.contains(date.mdKey) } ?? allCases[0]
    }
}
