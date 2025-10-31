//
//  C.swift
//  DateCalculator
//
//  Created by Dmitri  on 27.10.25.
//

import UIKit

/// App color palette, supports light/dark mode dynamically.
struct C {
    
    // MARK: - Primary App Colors
    /// Primary dynamic accent color
    static let mazarineBlue = UIColor { trait in
        if trait.userInterfaceStyle == .dark {
            return UIColor(red: 0.33, green: 0.50, blue: 0.80, alpha: 1.0) // #5480CC
        } else {
            return UIColor(red: 0.15, green: 0.24, blue: 0.46, alpha: 1.0) // #263D75
        }
    }
    
    static let chiGong = UIColor { trait in
        if trait.userInterfaceStyle == .dark {
            return UIColor(red: 0.99, green: 0.24, blue: 0.24, alpha: 1.00) // #FC3D3D
        } else {
            return UIColor(red: 0.84, green: 0.19, blue: 0.19, alpha: 1.00) // #D63232
        }
    }
    
    static let royalBlue = UIColor { trait in
        if trait.userInterfaceStyle == .dark {
            return UIColor(red: 0.24, green: 0.36, blue: 0.61, alpha: 1.00) // #3C5C9C
        } else {
            return UIColor(red: 0.22, green: 0.40, blue: 0.84, alpha: 1.00) // #3867D6
        }
    }
    
    static let veryBerry = UIColor { trait in
        if trait.userInterfaceStyle == .dark {
            return UIColor(red: 0.90, green: 0.55, blue: 0.70, alpha: 1.00) // #E68CB3
        } else {
            return UIColor(red: 0.71, green: 0.20, blue: 0.44, alpha: 1.00) // #B53570
        }
    }

    static let mediterraneanSea = UIColor { trait in
        if trait.userInterfaceStyle == .dark {
            return UIColor(red: 0.32, green: 0.74, blue: 0.82, alpha: 1.00) // #51BFD0
        } else {
            return UIColor(red: 0.07, green: 0.54, blue: 0.65, alpha: 1.00) // #1289A6
        }
    }

    static let merchantMarineBlue = UIColor { trait in
        if trait.userInterfaceStyle == .dark {
            return UIColor(red: 0.36, green: 0.56, blue: 0.96, alpha: 1.00) // #5D8FF5
        } else {
            return UIColor(red: 0.02, green: 0.32, blue: 0.87, alpha: 1.00) // #0552DE
        }
    }
    
    
    // MARK: - Cards Palette
    struct Cards {
        static let sourLemon = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.47, green: 0.42, blue: 0.27, alpha: 1.0) // #786B45
            } else {
                return UIColor(red: 1.00, green: 0.92, blue: 0.65, alpha: 1.00) // #FFE8A6
            }
        }
        
        static let innuendo = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.78, green: 0.80, blue: 0.85, alpha: 0.45) // #C7CCD8
            } else {
                return UIColor(red: 0.65, green: 0.69, blue: 0.76, alpha: 0.30) // #A6B0C2
            }
        }
        
        static let selectedBlue = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.45, green: 0.55, blue: 0.68, alpha: 0.55) // #738BB0
            } else {
                return UIColor(red: 0.70, green: 0.84, blue: 1.00, alpha: 0.60) // #B3D6FF
            }
        }
        
        static let customGrey = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.12, green: 0.15, blue: 0.20, alpha: 1.00) // #1E2633
            } else {
                return UIColor(red: 0.92, green: 0.95, blue: 0.98, alpha: 1.00) // #EBF2FA
            }
        }
        
        static let customYellow = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.75, green: 0.66, blue: 0.36, alpha: 1.0) // #BFA95C
            } else {
                return UIColor(red: 1.00, green: 0.96, blue: 0.77, alpha: 1.00) // #FFF5C4
            }
        }
        
        static let customGreen = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.22, green: 0.50, blue: 0.47, alpha: 1.00) // #397F78
            } else {
                return UIColor(red: 0.70, green: 0.86, blue: 0.82, alpha: 1.00) // #B3DCD1
            }
        }
        
        static let customPurple = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.47, green: 0.38, blue: 0.55, alpha: 1.00) // #775F8C
            } else {
                return UIColor(red: 0.86, green: 0.75, blue: 0.90, alpha: 1.00) // #DBC0E6
            }
        }
        
        static let customBlue = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.25, green: 0.38, blue: 0.55, alpha: 1.00) // #40608C
            } else {
                return UIColor(red: 0.77, green: 0.86, blue: 0.96, alpha: 1.00) // #C4DBF5
            }
        }
        
        static let customPurpleLight = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.54, green: 0.47, blue: 0.61, alpha: 1.00) // #8A78A0
            } else {
                return UIColor(red: 0.95, green: 0.90, blue: 0.99, alpha: 1.00) // #F2E6FC
            }
        }
        
        static let waterfall = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.20, green: 0.56, blue: 0.54, alpha: 0.40) // #33908A
            } else {
                return UIColor(red: 0.22, green: 0.68, blue: 0.66, alpha: 0.40) // #38ADA9
            }
        }
        
        static let lynxWhite = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.25, green: 0.27, blue: 0.32, alpha: 0.20) // #404552
            } else {
                return UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 0.20) // #F5F5FA
            }
        }
        
        static let shyMoment = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.48, green: 0.45, blue: 0.90, alpha: 1.00) // #7A73E6
            } else {
                return UIColor(red: 0.64, green: 0.61, blue: 1.00, alpha: 1.00) // #A29BFF
            }
        }
        
        static let fadedPoster = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.28, green: 0.70, blue: 0.70, alpha: 1.00) // #47B3B3
            } else {
                return UIColor(red: 0.51, green: 0.93, blue: 0.93, alpha: 1.00) // #82EEED
            }
        }
        
        static let cityLights = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.25, green: 0.27, blue: 0.30, alpha: 0.40) // #40464C
            } else {
                return UIColor(red: 0.87, green: 0.90, blue: 0.91, alpha: 0.40) // #DEE6E8
            }
        }
        
        static let pinkGlamour = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.80, green: 0.30, blue: 0.30, alpha: 1.00) // #CC4D4D
            } else {
                return UIColor(red: 1.00, green: 0.46, blue: 0.46, alpha: 1.00) // #FF7575
            }
        }
        
        static let goldenSend = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.65, green: 0.52, blue: 0.20, alpha: 0.70) // #A68433
            } else {
                return UIColor(red: 0.93, green: 0.80, blue: 0.41, alpha: 0.70) // #EDCC69
            }
        }
        
        static let highBlue = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.16, green: 0.43, blue: 0.65, alpha: 0.40) // #296EAA
            } else {
                return UIColor(red: 0.27, green: 0.67, blue: 0.95, alpha: 0.40) // #44ABF2
            }
        }
        
        static let blueHorizon = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.18, green: 0.23, blue: 0.33, alpha: 0.20) // #2E3B54
            } else {
                return UIColor(red: 0.29, green: 0.40, blue: 0.52, alpha: 0.20) // #496682
            }
        }
        
        static let lightPurple = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.44, green: 0.29, blue: 0.73, alpha: 0.40) // #714BB9
            } else {
                return UIColor(red: 0.65, green: 0.37, blue: 0.92, alpha: 0.40) // #A560EB
            }
        }
        
        static let yeuGaungLanBlue = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.10, green: 0.17, blue: 0.40, alpha: 0.20) // #1A2B66
            } else {
                return UIColor(red: 0.12, green: 0.22, blue: 0.60, alpha: 0.20) // #1E3899
            }
        }
        
        static let goodSamaritan = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.18, green: 0.29, blue: 0.38, alpha: 0.20) // #2E4A61
            } else {
                return UIColor(red: 0.24, green: 0.39, blue: 0.51, alpha: 0.20) // #3E6482
            }
        }
        
        static let squachBlossom = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.73, green: 0.56, blue: 0.18, alpha: 0.40) // #BA8F2E
            } else {
                return UIColor(red: 0.96, green: 0.73, blue: 0.23, alpha: 0.40) // #F5BA3A
            }
        }
        
        static let swanWhite = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.55, green: 0.55, blue: 0.50, alpha: 0.40) // #8C8C80
            } else {
                return UIColor(red: 0.97, green: 0.95, blue: 0.89, alpha: 0.40) // #F8F4E3
            }
        }
        
        static let rizeNshine = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.70, green: 0.55, blue: 0.15, alpha: 0.50) // #B38C26
            } else {
                return UIColor(red: 0.98, green: 0.77, blue: 0.19, alpha: 0.50) // #F9C532
            }
        }
        
        static let vanadylBlue = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.00, green: 0.46, blue: 0.70, alpha: 0.70) // #0075B3
            } else {
                return UIColor(red: 0.00, green: 0.59, blue: 0.90, alpha: 0.70) // #0096E6
            }
        }
        
        static let mandariSorbet = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.78, green: 0.49, blue: 0.12, alpha: 0.50) // #C67D1F
            } else {
                return UIColor(red: 1.00, green: 0.69, blue: 0.25, alpha: 0.50) // #FFB043
            }
        }
    }
}

// MARK: - Dynamic Label Colors for Cards
extension C.Cards {
    
    // MARK: - Title Label Colors (контрастный заголовок)
    static func titleLabelColor(for background: UIColor) -> UIColor {
        UIColor { trait in
            let isDark = trait.userInterfaceStyle == .dark
            switch background {
            case C.Cards.sourLemon:         return isDark ? UIColor(red: 0.95, green: 0.87, blue: 0.52, alpha: 1.0) // #F2DD84
                                                        : UIColor(red: 0.58, green: 0.50, blue: 0.20, alpha: 1.0) // #947F33
            case C.Cards.innuendo:          return isDark ? UIColor(red: 0.75, green: 0.78, blue: 0.84, alpha: 1.0) // #BFC7D6
                                                        : UIColor(red: 0.36, green: 0.39, blue: 0.45, alpha: 1.0) // #5C6373
            case C.Cards.selectedBlue:      return isDark ? UIColor(red: 0.63, green: 0.77, blue: 0.95, alpha: 1.0) // #A0C4F2
                                                        : UIColor(red: 0.34, green: 0.49, blue: 0.70, alpha: 1.0) // #577DB2
            case C.Cards.customGrey:        return isDark ? UIColor(red: 0.70, green: 0.77, blue: 0.88, alpha: 1.0) // #B2C4E0
                                                        : UIColor(red: 0.32, green: 0.36, blue: 0.42, alpha: 1.0) // #525C6B
            case C.Cards.customYellow:      return isDark ? UIColor(red: 0.93, green: 0.84, blue: 0.47, alpha: 1.0) // #EDCF78
                                                        : UIColor(red: 0.64, green: 0.55, blue: 0.22, alpha: 1.0) // #A38C38
            case C.Cards.customGreen:       return isDark ? UIColor(red: 0.60, green: 0.86, blue: 0.80, alpha: 1.0) // #99DCD0
                                                        : UIColor(red: 0.18, green: 0.46, blue: 0.42, alpha: 1.0) // #2E766C
            case C.Cards.customPurple:      return isDark ? UIColor(red: 0.70, green: 0.60, blue: 0.85, alpha: 1.0) // #B299D9
                                                        : UIColor(red: 0.47, green: 0.38, blue: 0.55, alpha: 1.0) // #775F8C
            case C.Cards.customBlue:        return isDark ? UIColor(red: 0.65, green: 0.79, blue: 0.96, alpha: 1.0) // #A5C9F5
                                                        : UIColor(red: 0.30, green: 0.42, blue: 0.62, alpha: 1.0) // #4D6BA0
            case C.Cards.customPurpleLight: return isDark ? UIColor(red: 0.78, green: 0.72, blue: 0.88, alpha: 1.0) // #C7B7E0
                                                        : UIColor(red: 0.55, green: 0.45, blue: 0.67, alpha: 1.0) // #8C73AA
            case C.Cards.waterfall:         return isDark ? UIColor(red: 0.45, green: 0.76, blue: 0.75, alpha: 1.0) // #73C1BE
                                                        : UIColor(red: 0.16, green: 0.46, blue: 0.45, alpha: 1.0) // #297573
            case C.Cards.lynxWhite:         return isDark ? UIColor(red: 0.70, green: 0.72, blue: 0.78, alpha: 1.0) // #B3B8C7
                                                        : UIColor(red: 0.40, green: 0.42, blue: 0.48, alpha: 1.0) // #667A8F
            case C.Cards.shyMoment:         return isDark ? UIColor(red: 0.66, green: 0.64, blue: 0.95, alpha: 1.0) // #A89FF2
                                                        : UIColor(red: 0.42, green: 0.40, blue: 0.90, alpha: 1.0) // #6B66E6
            case C.Cards.fadedPoster:       return isDark ? UIColor(red: 0.60, green: 0.88, blue: 0.88, alpha: 1.0) // #99E0E0
                                                        : UIColor(red: 0.26, green: 0.60, blue: 0.60, alpha: 1.0) // #429999
            case C.Cards.cityLights:        return isDark ? UIColor(red: 0.70, green: 0.72, blue: 0.74, alpha: 1.0) // #B3B8BD
                                                        : UIColor(red: 0.36, green: 0.38, blue: 0.40, alpha: 1.0) // #5C6166
            case C.Cards.pinkGlamour:       return isDark ? UIColor(red: 0.86, green: 0.45, blue: 0.45, alpha: 1.0) // #DB7373
                                                        : UIColor(red: 0.52, green: 0.09, blue: 0.09, alpha: 1.0) // #841717
            case C.Cards.goldenSend:        return isDark ? UIColor(red: 0.90, green: 0.77, blue: 0.35, alpha: 1.0) // #E6C458
                                                        : UIColor(red: 0.55, green: 0.46, blue: 0.20, alpha: 1.0) // #8C7533
            case C.Cards.highBlue:          return isDark ? UIColor(red: 0.45, green: 0.65, blue: 0.95, alpha: 1.0) // #73A6F2
                                                        : UIColor(red: 0.20, green: 0.45, blue: 0.70, alpha: 1.0) // #3373B3
            case C.Cards.blueHorizon:       return isDark ? UIColor(red: 0.55, green: 0.65, blue: 0.80, alpha: 1.0) // #8CA6CC
                                                        : UIColor(red: 0.18, green: 0.23, blue: 0.33, alpha: 1.0) // #2E3B54
            case C.Cards.lightPurple:       return isDark ? UIColor(red: 0.70, green: 0.60, blue: 0.90, alpha: 1.0) // #B399E6
                                                        : UIColor(red: 0.35, green: 0.25, blue: 0.55, alpha: 1.0) // #59408C
            case C.Cards.yeuGaungLanBlue:   return isDark ? UIColor(red: 0.45, green: 0.55, blue: 0.80, alpha: 1.0) // #7390CC
                                                        : UIColor(red: 0.10, green: 0.17, blue: 0.40, alpha: 1.0) // #1A2B66
            case C.Cards.goodSamaritan:     return isDark ? UIColor(red: 0.60, green: 0.75, blue: 0.88, alpha: 1.0) // #99BFE0
                                                        : UIColor(red: 0.22, green: 0.30, blue: 0.42, alpha: 1.0) // #384D6B
            case C.Cards.squachBlossom:     return isDark ? UIColor(red: 0.90, green: 0.75, blue: 0.30, alpha: 1.0) // #E6BF4D
                                                        : UIColor(red: 0.58, green: 0.45, blue: 0.18, alpha: 1.0) // #94732E
            case C.Cards.swanWhite:         return isDark ? UIColor(red: 0.80, green: 0.80, blue: 0.72, alpha: 1.0) // #CCCBB8
                                                        : UIColor(red: 0.55, green: 0.55, blue: 0.50, alpha: 1.0) // #8C8C80
            case C.Cards.rizeNshine:        return isDark ? UIColor(red: 0.88, green: 0.70, blue: 0.28, alpha: 1.0) // #E0B346
                                                        : UIColor(red: 0.58, green: 0.44, blue: 0.12, alpha: 1.0) // #94701F
            case C.Cards.vanadylBlue:       return isDark ? UIColor(red: 0.40, green: 0.70, blue: 0.95, alpha: 1.0) // #66B3F2
                                                        : UIColor(red: 0.00, green: 0.36, blue: 0.60, alpha: 1.0) // #005C99
            case C.Cards.mandariSorbet:     return isDark ? UIColor(red: 0.92, green: 0.65, blue: 0.30, alpha: 1.0) // #E8A74D
                                                        : UIColor(red: 0.70, green: 0.45, blue: 0.12, alpha: 1.0) // #B3721F
            default: return .secondaryLabel
            }
        }
    }
    
    // MARK: - Name Label Colors (нижние подписи, менее контрастные)
    static func nameLabelColor(for background: UIColor) -> UIColor {
        UIColor { trait in
            let isDark = trait.userInterfaceStyle == .dark
            switch background {
            case C.Cards.sourLemon:         return isDark ? UIColor(red: 0.90, green: 0.82, blue: 0.55, alpha: 1.0) // #E6D18C
                                                        : UIColor(red: 0.39, green: 0.33, blue: 0.07, alpha: 1.0) // #635411
            case C.Cards.innuendo:          return isDark ? UIColor(red: 0.63, green: 0.66, blue: 0.72, alpha: 1.0) // #A1A8B8
                                                        : UIColor(red: 0.25, green: 0.27, blue: 0.32, alpha: 1.0) // #404552
            case C.Cards.selectedBlue:      return isDark ? UIColor(red: 0.50, green: 0.67, blue: 0.88, alpha: 1.0) // #80AADC
                                                        : UIColor(red: 0.22, green: 0.33, blue: 0.52, alpha: 1.0) // #385486
            case C.Cards.customGrey:        return isDark ? UIColor(red: 0.65, green: 0.70, blue: 0.78, alpha: 1.0) // #A6B3C7
                                                        : UIColor(red: 0.29, green: 0.32, blue: 0.38, alpha: 1.0) // #4A515F
            case C.Cards.customYellow:      return isDark ? UIColor(red: 0.87, green: 0.78, blue: 0.42, alpha: 1.0) // #DEC66B
                                                        : UIColor(red: 0.42, green: 0.36, blue: 0.09, alpha: 1.0) // #6B5C18
            case C.Cards.customGreen:       return isDark ? UIColor(red: 0.42, green: 0.67, blue: 0.63, alpha: 1.0) // #6BAA9F
                                                        : UIColor(red: 0.13, green: 0.34, blue: 0.31, alpha: 1.0) // #214F4E
            case C.Cards.customPurple:      return isDark ? UIColor(red: 0.63, green: 0.54, blue: 0.76, alpha: 1.0) // #A08AC2
                                                        : UIColor(red: 0.35, green: 0.27, blue: 0.46, alpha: 1.0) // #594573
            case C.Cards.customBlue:        return isDark ? UIColor(red: 0.53, green: 0.69, blue: 0.88, alpha: 1.0) // #88B0E0
                                                        : UIColor(red: 0.25, green: 0.36, blue: 0.54, alpha: 1.0) // #405C8A
            case C.Cards.customPurpleLight: return isDark ? UIColor(red: 0.68, green: 0.62, blue: 0.80, alpha: 1.0) // #AD9FCC
                                                        : UIColor(red: 0.43, green: 0.36, blue: 0.56, alpha: 1.0) // #6E5C8F
            case C.Cards.waterfall:         return isDark ? UIColor(red: 0.38, green: 0.70, blue: 0.69, alpha: 1.0) // #61B3B0
                                                        : UIColor(red: 0.09, green: 0.33, blue: 0.32, alpha: 1.0) // #175453
            default: return .secondaryLabel
            }
        }
    }
}
