//
//  Protocols.swift
//  DateCalculator
//
//  Created by Dmitri  on 25.10.25.
//

import Foundation

//MARK: - Common types used in different classes
//Notify ValuesView about layoytType selected in DateCalculatorViewModel
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
