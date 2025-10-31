//
//  Protocols.swift
//  DateCalculator
//
//  Created by Dmitry on 25.10.25.
//
//  Description:
//  Contains shared protocol and layout type definitions used across
//  the Date Calculator app (e.g., for layout switching in views).
//

import Foundation

// MARK: - Layout Display Protocol
/// Protocol adopted by views that can display content
/// in different layout styles (e.g. `.row` or `.grid`).
protocol LayoutDisplayable: AnyObject {
    /// Current layout type applied to the view.
    var layoutType: LayoutType { get set }
}

// MARK: - Layout Type
/// Defines the available layout modes used throughout the app.
enum LayoutType: String {
    case row
    case grid
    
    /// SF Symbol name representing each layout type.
    var iconName: String {
        switch self {
        case .row:
            return "circle.grid.2x1.fill"
        case .grid:
            return "circle.grid.3x3.fill"
        }
    }
}
