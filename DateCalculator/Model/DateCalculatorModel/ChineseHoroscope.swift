//
//  ChineseHoroscope.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 18.10.2025.
//
//  Description:
//  Provides a Chinese horoscope model based on the Chinese lunar calendar.
//  Calculates Zodiac animal, Element, and Energy (Yin/Yang) for a given date.
//

import Foundation

// MARK: - Chinese Horoscope Structure
/// Represents the traditional Chinese horoscope for a specific date.
/// Contains Zodiac (animal), Element, and Energy (Yin/Yang).
struct ChineseHoroscope {
    
    // MARK: - Zodiac (12 Animals)
    /// The 12 Chinese zodiac animals, repeating every 12 years.
    enum Zodiac: String, CaseIterable {
        case rat = "Rat"
        case ox = "Ox"
        case tiger = "Tiger"
        case rabbit = "Rabbit"
        case dragon = "Dragon"
        case snake = "Snake"
        case horse = "Horse"
        case goat = "Goat"
        case monkey = "Monkey"
        case rooster = "Rooster"
        case dog = "Dog"
        case pig = "Pig"
        
        /// Human-readable name.
        var name: String { rawValue }
        /// Section title used in UI.
        var title: String { "Chinese Zodiac" }
        
        /// Emoji icon representing each animal.
        var icon: String {
            switch self {
            case .rat: return "🐀"
            case .ox: return "🐂"
            case .tiger: return "🐅"
            case .rabbit: return "🐇"
            case .dragon: return "🐉"
            case .snake: return "🐍"
            case .horse: return "🐎"
            case .goat: return "🐐"
            case .monkey: return "🐒"
            case .rooster: return "🐓"
            case .dog: return "🐕"
            case .pig: return "🐖"
            }
        }
    }
    
    // MARK: - Element (5 Elements)
    /// The five classical Chinese elements, repeating every 10 years (each twice).
    enum Element: String, CaseIterable {
        case wood = "Wood"
        case fire = "Fire"
        case earth = "Earth"
        case metal = "Metal"
        case water = "Water"
        
        var name: String { rawValue }
        var title: String { "Fixed Element" }
        
        /// Emoji icon representing the element.
        var icon: String {
            switch self {
            case .wood: return "🌳"
            case .fire: return "🔥"
            case .earth: return "🌎"
            case .metal: return "🔱"
            case .water: return "🌊"
            }
        }
    }
    
    // MARK: - Energy (Yin / Yang)
    /// Represents Yin or Yang energy, alternating every year.
    enum Energy: String {
        case yin = "Yin"
        case yang = "Yang"
        
        var name: String { rawValue }
        var title: String { "Energy" }
        
        /// Symbol for both Yin and Yang (☯️).
        var icon: String {
            switch self {
            case .yin: return "☯️"
            case .yang: return "☯️"
            }
        }
    }
    
    // MARK: - Properties
    /// The animal sign for the year.
    let zodiac: Zodiac
    /// The elemental association for the year.
    let element: Element
    /// The energy polarity (Yin or Yang).
    let energy: Energy
    
    // MARK: - Internal Helpers
    
    /// Ensures positive modulo results (for safe array indexing).
    private static func posMod(_ x: Int, _ m: Int) -> Int {
        ((x % m) + m) % m
    }
    
    // MARK: - Main Lookup Method
    /// Returns the full Chinese horoscope for a given date.
    ///
    /// - Parameter date: The date to calculate the horoscope for.
    /// - Returns: A `ChineseHoroscope` instance with zodiac, element, and energy.
    static func get(for date: Date) -> ChineseHoroscope {
        let chineseCalendar = Calendar(identifier: .chinese)
        let comps = chineseCalendar.dateComponents([.year], from: date)
        
        guard let cyclicalYear = comps.year else {
            // Fallback to default values to prevent crashes.
            return ChineseHoroscope(zodiac: .rat, element: .wood, energy: .yang)
        }
        
        // The Chinese calendar operates on a 60-year cycle.
        let yearIndex = cyclicalYear - 1
        
        // 12 Earthly Branches — determine the animal.
        let branchIndex = posMod(yearIndex, 12)
        
        // 10 Heavenly Stems — determine element and energy.
        let stemIndex = posMod(yearIndex, 10)
        
        // Each element repeats twice (Yang then Yin).
        let elementIndex = stemIndex / 2
        
        // Even stems are Yang, odd stems are Yin.
        let energy: Energy = (stemIndex % 2 == 0) ? .yang : .yin
        
        // Ensure correct zodiac and element ordering.
        let zodiac = Zodiac.allCases[branchIndex]
        let element = Element.allCases[elementIndex]
        
        return ChineseHoroscope(zodiac: zodiac, element: element, energy: energy)
    }
}
