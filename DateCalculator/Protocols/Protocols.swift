//
//  Protocols.swift
//  DateCalculator
//
//  Created by Dmitri  on 25.10.25.
//

import Foundation

protocol LayoutDisplayable: AnyObject {
    var layoutType: LayoutType { get set }
    //var segmentIndex: Int { get set }
    //var dateType: DateCalculatorViewModel.DateType { get set }
}

enum LayoutType: String {
    case row
    case grid
    
    var iconName: String {
        switch self {
        case .row: return "circle.grid.2x1.fill"
        case .grid: return "circle.grid.3x3.fill"
        }
    }
}

//
protocol ValuesViewUpdatable: AnyObject {
    func updateValues(segments: [String], selectedIndex: Int, from start: Date, to end: Date)
}
