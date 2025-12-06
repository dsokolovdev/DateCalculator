//
//  ButtonConfigs.swift
//  DateCalculator
//
//  Created by Dmitri  on 06.12.25.
//

import UIKit

// MARK: - Buttons Configuration
enum ButtonsConfig {
    private static let symbolConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
    
    private static let colorConfigNormalMode = UIImage.SymbolConfiguration(
        paletteColors: [.label, .label]
    )
    private static let colorConfigCalculationMode = UIImage.SymbolConfiguration(
        paletteColors: [.label, .tertiaryLabel]
    )
    private static let colorConfigDisabled = UIImage.SymbolConfiguration(
        paletteColors: [.tertiaryLabel, .tertiaryLabel]
    )
    
    static let normalModeConfig = symbolConfig.applying(colorConfigNormalMode)
    static let calculationModeConfing = symbolConfig.applying(colorConfigCalculationMode)
    static let disabledConfig = symbolConfig.applying(colorConfigDisabled)
    
    // MARK: - Keyboard Buttons
    enum KeyBoard {
        private static let baseConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        private static let colorInactiveConfig = UIImage.SymbolConfiguration(
            paletteColors: [.systemGray, .tertiaryLabel]
        )
        static let generalInactiveConfig = baseConfig.applying(colorInactiveConfig)
        
        // MARK: - Erase Button
        private static let colorActiveConfigErase = UIImage.SymbolConfiguration(
            paletteColors: [.systemGray, C.chiGong]
        )
        static let eraseActiveConfig = baseConfig.applying(colorActiveConfigErase)
        
        private static let colorActiveConfigEraseClick = UIImage.SymbolConfiguration(
            paletteColors: [C.chiGong, C.veryBerry]
        )
        static let eraseActiveConfigClick = baseConfig.applying(colorActiveConfigEraseClick)
        
        private static let colorInactiveConfigErase = UIImage.SymbolConfiguration(
            paletteColors: [.tertiaryLabel, C.chiGong]
        )
        static let eraseInactiveConfig = baseConfig.applying(colorInactiveConfigErase)
        
        // MARK: - Minus Button
        private static let colorActiveConfigMinus = UIImage.SymbolConfiguration(
            paletteColors: [.systemGray, C.Cards.goldenSend]
        )
        static let minusActiveConfig = baseConfig.applying(colorActiveConfigMinus)
        
        private static let colorInactiveConfigMinus = UIImage.SymbolConfiguration(
            paletteColors: [.systemGray, .tertiaryLabel]
        )
        static let minusInactiveConfig = baseConfig.applying(colorInactiveConfigMinus)
        
        // MARK: - Plus Button
        private static let colorActiveConfigPlus = UIImage.SymbolConfiguration(
            paletteColors: [.systemGray, C.Cards.goldenSend]
        )
        static let plusActiveConfig = baseConfig.applying(colorActiveConfigPlus)
        
        private static let colorInactiveConfigPlus = UIImage.SymbolConfiguration(
            paletteColors: [.systemGray, .tertiaryLabel]
        )
        static let plusInactiveConfig = baseConfig.applying(colorInactiveConfigPlus)
    }
}
