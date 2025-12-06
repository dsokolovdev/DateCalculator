//
//  CommonTypes.swift
//  DateCalculator
//
//  Created by Dmitri  on 06.12.25.
//

import UIKit

// MARK: - Layout Display Protocol
/// Protocol for views capable of switching between different layout styles.
/// Used by views that support `.row` and `.grid` presentation.
protocol LayoutDisplayable: AnyObject {
    /// Current layout mode applied to the view.
    var layoutType: LayoutType { get set }
}

// MARK: - Layout Type
/// Defines available display layout modes.
enum LayoutType: String {
    case row
    case grid
    
    /// SF Symbol name representing each layout visually.
    var iconName: String {
        switch self {
        case .row:
            return "circle.grid.2x1.fill"
        case .grid:
            return "circle.grid.3x3.fill"
        }
    }
}

// MARK: - Period Types
/// Supported period segments displayed in date calculations.
enum Period: String, CaseIterable {
    case year  = "Year"
    case month = "Month"
    case week  = "Week"
    case day   = "Day"
    
    /// User-visible string value.
    var value: String { rawValue }
}

// MARK: - Day Of Week (Special Cases)
/// Used for weekend coloring and label highlighting.
enum DayOfWeek: String {
    case Saturday, Sunday
    var name: String { rawValue }
}

// MARK: - Screen Size Flags
/// Detects small screen devices (e.g., iPhone SE / Mini).
var isSmallScreen: Bool {
    UIScreen.main.bounds.height < 750
}

// MARK: - Screen Classes
/// Categorizes devices for UI scaling.
enum ScreenClass {
    case se
    case mini
    case normal
    case proMax
    case iPad
}

/// Returns the current device class used for adaptive UI sizing.
var screenClass: ScreenClass {
    if UIDevice.current.userInterfaceIdiom == .pad {
        return .iPad
    }
    
    let h = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    
    switch h {
    case ..<700:    return .se
    case 700..<830: return .mini
    case 830..<900: return .normal
    default:        return .proMax
    }
}

// MARK: - Scale Factor
/// Global UI scale factor based on device class.
/// Used across the app to proportionally size elements.
var scaleFactor: CGFloat {
    switch screenClass {
    case .se:     return 0.86
    case .mini:   return 0.95
    case .normal: return 1.0
    case .proMax: return 1.08
    case .iPad:   return 1.18
    }
}

// MARK: - Global Keyboard Adjustment
/// Dynamic vertical offset used when keyboard is shown.
var keyboardkAdjustment: CGFloat = 0
