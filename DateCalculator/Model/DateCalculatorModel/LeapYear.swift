//
//  LipYear.swift
//  DateCalculator
//
//  Created by Dmitri  on 21.10.25.
//

import UIKit

struct LeapYear {
    
    enum YearType: String {
        case leapYear = "Leap Year"
        case commonYear = "Common Year"
        
        var name: String { rawValue }
    }
    
    var title: String { "Year" }
    //var symbol: String { "✨" }
    var symbol: String { "sparkles" } // SF Symbol
    var color: UIColor
    var type: YearType
    
    init(isLeap: Bool) {
        self.type = isLeap ? .leapYear : .commonYear
        self.color = isLeap ? .systemYellow : UIColor.secondaryLabel.withAlphaComponent(0.2)
    }
}

//import Foundation
//
//struct LeapYear {
//    
//    enum YearType: String {
//        case leap = "Leap Year"
//        case common = "Non-leap Year"
//        
//        var name: String { rawValue }
//    }
//    
//    enum Icon: String {
//        case star = "✨"
//        case emptyStar = "⚪️"
//        
//        var symbol: String { rawValue }
//    }
//    
//    let title: String = "Year"
//    let icon: Icon
//    let type: YearType
//    
//    init(isLeap: Bool) {
//        self.icon = isLeap ? .star : .emptyStar
//        self.type = isLeap ? .leap : .common
//    }
//}
