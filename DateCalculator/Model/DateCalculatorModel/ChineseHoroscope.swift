//
//  ChineseHoroscope.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 2025.
//

import Foundation

struct ChineseHoroscope {
    
    // MARK: - Zodiac (12 животных)
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
        
        var name: String { rawValue }
        var title: String { "Chinese Zodiac" }
        
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
    
    // MARK: - Element (5 стихий)
    enum Element: String, CaseIterable {
        case wood = "Wood"
        case fire = "Fire"
        case earth = "Earth"
        case metal = "Metal"
        case water = "Water"
        
        var name: String { rawValue }
        var title: String { "Fixed Element" }
        
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
    
    // MARK: - Energy (инь / ян)
    enum Energy: String {
        case yin = "Yin"
        case yang = "Yang"
        
        var name: String { rawValue }
        var title: String { "Energy" }
        
        var icon: String {
            switch self {
            case .yin: return "☯️"
            case .yang: return "☯️"
            }
        }
    }
    
    // MARK: - Properties
    let zodiac: Zodiac
    let element: Element
    let energy: Energy
    
    // MARK: - Lookup Method
    static func get(for date: Date) -> ChineseHoroscope {
        let chineseCalendar = Calendar(identifier: .chinese)
        let components = chineseCalendar.dateComponents([.year], from: date)
        guard let chineseYear = components.year else {
            fatalError("Failed to extract Chinese year from date.")
        }
        
        // Индекс животного (12-летний цикл)
        let zodiacIndex = (chineseYear - 4) % 12
        // Индекс элемента (каждый элемент повторяется 2 года, всего 10-летний цикл)
        let elementIndex = ((chineseYear - 4) % 10) / 2
        // Энергия (чередуется каждый год)
        let energy: Energy = (chineseYear % 2 == 0) ? .yang : .yin
        
        let zodiac = Zodiac.allCases[zodiacIndex]
        let element = Element.allCases[elementIndex]
        
        return ChineseHoroscope(zodiac: zodiac, element: element, energy: energy)
    }
}
