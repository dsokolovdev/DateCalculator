//
//  WesternHoroscope.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 2025.
//

import Foundation

struct WesternHoroscope {
    
    // MARK: - Zodiac Signs
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
        
        var name: String { rawValue }
        var title: String { "Western Zodiac" }
        
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
    enum Element: String {
        case air = "Air"
        case water = "Water"
        case fire = "Fire"
        case earth = "Earth"
        
        var name: String { rawValue }
        var title: String { "Element" }
        
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
    let zodiac: Zodiac
    let element: Element
    let range: ClosedRange<Int>
    
    // MARK: - All Signs
    static let allCases: [WesternHoroscope] = [
        WesternHoroscope(zodiac: .capricorn, element: .earth, range: 101...119),
        WesternHoroscope(zodiac: .aquarius, element: .air, range: 120...218),
        WesternHoroscope(zodiac: .pisces, element: .water, range: 219...320),
        WesternHoroscope(zodiac: .aries, element: .fire, range: 321...419),
        WesternHoroscope(zodiac: .taurus, element: .earth, range: 420...520),
        WesternHoroscope(zodiac: .gemini, element: .air, range: 521...621),
        WesternHoroscope(zodiac: .cancer, element: .water, range: 622...722),
        WesternHoroscope(zodiac: .leo, element: .fire, range: 723...822),
        WesternHoroscope(zodiac: .virgo, element: .earth, range: 823...922),
        WesternHoroscope(zodiac: .libra, element: .air, range: 923...1023),
        WesternHoroscope(zodiac: .scorpio, element: .water, range: 1024...1121),
        WesternHoroscope(zodiac: .sagittarius, element: .fire, range: 1122...1221),
        WesternHoroscope(zodiac: .capricorn, element: .earth, range: 1222...1231)
    ]
    
    // MARK: - Lookup
    static func get(for date: Date) -> WesternHoroscope {
        //let md = Int(date.formatted(.iso8601.month().day().dateSeparator(.omitted))) ?? 0
        return allCases.first { $0.range.contains(date.mdKey) } ?? allCases[0]
    }
}
