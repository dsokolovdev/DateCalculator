//
//  C.swift
//  DateCalculator
//
//  Created by Dmitri  on 27.10.25.
//

import UIKit

/// App color palette, supports light/dark mode dynamically.
struct C {
    /// Primary dynamic accent color
    static let mazarineBlue = UIColor { trait in
        if trait.userInterfaceStyle == .dark {
            return UIColor(red: 0.33, green: 0.50, blue: 0.80, alpha: 1.0)
        } else {
            return UIColor(red: 0.15, green: 0.24, blue: 0.46, alpha: 1.0)
        }
    }
    
    /// Secondary red accent for warnings or energy
    static let chiGong = UIColor { trait in
        if trait.userInterfaceStyle == .dark {
            return UIColor(red: 0.99, green: 0.24, blue: 0.24, alpha: 1.00)
        } else {
            return UIColor(red: 0.84, green: 0.19, blue: 0.19, alpha: 1.00)
        }
    }
    
    static let royalBlue = UIColor { trait in
        if trait.userInterfaceStyle == .dark {
            return UIColor(red: 0.24, green: 0.36, blue: 0.61, alpha: 1.00)
        } else {
            return UIColor(red: 0.22, green: 0.40, blue: 0.84, alpha: 1.00)
        }
    }
    
    static let veryBerry = UIColor(red: 0.71, green: 0.20, blue: 0.44, alpha: 1.00)
    static let mediterraneanSea = UIColor(red: 0.07, green: 0.54, blue: 0.65, alpha: 1.00)
    static let merchantMarineBlue = UIColor(red: 0.02, green: 0.32, blue: 0.87, alpha: 1.00)
    
    
    struct Cards {
        static let sourLemon = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.47, green: 0.42, blue: 0.27, alpha: 1.0) // #786B45
            } else {
                return UIColor(red: 1.00, green: 0.92, blue: 0.65, alpha: 1.00) //yellow *
            }
        }
        
        static let innuendo = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.78, green: 0.80, blue: 0.85, alpha: 0.45)
            } else {
                return UIColor(red: 0.65, green: 0.69, blue: 0.76, alpha: 0.30) //grey *
            }
        }
        
        static let selectedBlue = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.45, green: 0.55, blue: 0.68, alpha: 0.55)
            } else {
                return UIColor(red: 0.70, green: 0.84, blue: 1.00, alpha: 0.60) //blue *
            }
        }
        
        static let customGrey = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.12, green: 0.15, blue: 0.20, alpha: 1.00)
            } else {
                return UIColor(red: 0.92, green: 0.95, blue: 0.98, alpha: 1.00)
            }
        }
        
        static let customYellow = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.75, green: 0.66, blue: 0.36, alpha: 1.0) // золотисто-оливковый #BFA95C
            } else {
                return UIColor(red: 1.00, green: 0.96, blue: 0.77, alpha: 1.00) // мягкий жёлтый #FFF5C4
            }
        }
        
        static let customGreen = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.22, green: 0.50, blue: 0.47, alpha: 1.00) // глубокий зелёно-синий #397F78
            } else {
                return UIColor(red: 0.70, green: 0.86, blue: 0.82, alpha: 1.00) // мятный #B3DCD1
            }
        }
        
        static let customPurple = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.47, green: 0.38, blue: 0.55, alpha: 1.00) // глубокий сиреневый #775F8C
            } else {
                return UIColor(red: 0.86, green: 0.75, blue: 0.90, alpha: 1.00) // нежно-сиреневый #DBC0E6
            }
        }
        
        static let customBlue = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.25, green: 0.38, blue: 0.55, alpha: 1.00) // тёмно-стальной #40608C
            } else {
                return UIColor(red: 0.77, green: 0.86, blue: 0.96, alpha: 1.00) // светлый голубой #C4DBF5
            }
        }
        
        static let customPurpleLight = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.54, green: 0.47, blue: 0.61, alpha: 1.00) // фиолетово-серый #8A78A0
            } else {
                return UIColor(red: 0.95, green: 0.90, blue: 0.99, alpha: 1.00) // светлый лавандовый #F2E6FC
            }
        }
        
        
        static let waterfall = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.20, green: 0.56, blue: 0.54, alpha: 0.40) // #33908A // глубокий морской зелёно-синий
            } else {
                return UIColor(red: 0.22, green: 0.68, blue: 0.66, alpha: 0.40)
            }
        }
        
        static let lynxWhite = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.25, green: 0.27, blue: 0.32, alpha: 0.20) // тёмно-серый с легкой синевой
            } else {
                return UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 0.20)
            }
        }
        
        static let shyMoment = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.48, green: 0.45, blue: 0.90, alpha: 1.00) // более глубокий фиолетовый
            } else {
                return UIColor(red: 0.64, green: 0.61, blue: 1.00, alpha: 1.00)
            }
        }
        
        static let fadedPoster = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.28, green: 0.70, blue: 0.70, alpha: 1.00) // мягкий бирюзово-зелёный
            } else {
                return UIColor(red: 0.51, green: 0.93, blue: 0.93, alpha: 1.00)
            }
        }
        
        static let cityLights = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.25, green: 0.27, blue: 0.30, alpha: 0.40) // тёмно-графитовый
            } else {
                return UIColor(red: 0.87, green: 0.90, blue: 0.91, alpha: 0.40)
            }
        }
        
        static let pinkGlamour = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.80, green: 0.30, blue: 0.30, alpha: 1.00) // глубокий красно-малиновый
            } else {
                return UIColor(red: 1.00, green: 0.46, blue: 0.46, alpha: 1.00)
            }
        }
        
        static let goldenSend = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.65, green: 0.52, blue: 0.20, alpha: 0.70) // бронзово-золотой
            } else {
                return UIColor(red: 0.93, green: 0.80, blue: 0.41, alpha: 0.70)
            }
        }
        
        static let highBlue = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.16, green: 0.43, blue: 0.65, alpha: 0.40) // насыщенный синий
            } else {
                return UIColor(red: 0.27, green: 0.67, blue: 0.95, alpha: 0.40)
            }
        }
        
        static let blueHorizon = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.18, green: 0.23, blue: 0.33, alpha: 0.20) // холодный стальной
            } else {
                return UIColor(red: 0.29, green: 0.40, blue: 0.52, alpha: 0.20)
            }
        }
        
        static let lightPurple = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.44, green: 0.29, blue: 0.73, alpha: 0.40) // приглушённый фиолетовый
            } else {
                return UIColor(red: 0.65, green: 0.37, blue: 0.92, alpha: 0.40)
            }
        }
        
        static let yeuGaungLanBlue = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.10, green: 0.17, blue: 0.40, alpha: 0.20) // глухой индиго
            } else {
                return UIColor(red: 0.12, green: 0.22, blue: 0.60, alpha: 0.20)
            }
        }
        
        static let goodSamaritan = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.18, green: 0.29, blue: 0.38, alpha: 0.20) // глубокий серо-синий
            } else {
                return UIColor(red: 0.24, green: 0.39, blue: 0.51, alpha: 0.20)
            }
        }
        
        static let squachBlossom = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.73, green: 0.56, blue: 0.18, alpha: 0.40) // янтарно-коричневый
            } else {
                return UIColor(red: 0.96, green: 0.73, blue: 0.23, alpha: 0.40)
            }
        }
        
        static let swanWhite = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.55, green: 0.55, blue: 0.50, alpha: 0.40) // сдержанный серо-бежевый
            } else {
                return UIColor(red: 0.97, green: 0.95, blue: 0.89, alpha: 0.40)
            }
        }
        
        static let rizeNshine = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.70, green: 0.55, blue: 0.15, alpha: 0.50) // бронзово-золотистый
            } else {
                return UIColor(red: 0.98, green: 0.77, blue: 0.19, alpha: 0.50)
            }
        }
        
        static let vanadylBlue = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.00, green: 0.46, blue: 0.70, alpha: 0.70) // глубокий морской синий
            } else {
                return UIColor(red: 0.00, green: 0.59, blue: 0.90, alpha: 0.70)
            }
        }
        
        static let mandariSorbet = UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 0.78, green: 0.49, blue: 0.12, alpha: 0.50) // приглушённый апельсиновый
            } else {
                return UIColor(red: 1.00, green: 0.69, blue: 0.25, alpha: 0.50)
            }
        }
    }
    
    
}

// MARK: - Dynamic Title / Name Colors
//extension C.Cards {
//
//    static func titleLabelColor(for background: UIColor) -> UIColor {
//        return UIColor { trait in
//            let isDark = (trait.userInterfaceStyle == .dark)
//
//            switch background {
//            case C.Cards.selectedBlue:
//                return isDark
//                ? UIColor(red: 0.63, green: 0.77, blue: 0.95, alpha: 1.0) // светлый стальной синий #A1C4F2
//                : UIColor(red: 0.34, green: 0.49, blue: 0.70, alpha: 1.0) // #6B94C7
//
//            case C.Cards.sourLemon:
//                return isDark
//                ? UIColor(red: 0.95, green: 0.85, blue: 0.42, alpha: 1.0) // золотисто-жёлтый #E1C95C
//                : UIColor(red: 0.58, green: 0.50, blue: 0.20, alpha: 1.0) // тёплый, чуть темнее желтого
//
//            case C.Cards.waterfall:
//                return isDark
//                ? UIColor(red: 0.45, green: 0.76, blue: 0.75, alpha: 1.0) // мягкий бирюзовый #73C2BF
//                : UIColor(red: 0.16, green: 0.46, blue: 0.45, alpha: 1.0) // тёмно-бирюзовый
//
//            case C.Cards.innuendo:
//                return isDark
//                ? UIColor(red: 0.70, green: 0.74, blue: 0.80, alpha: 1.0) // светло-графитовый #B3BCCB
//                : UIColor(red: 0.36, green: 0.39, blue: 0.45, alpha: 1.0) // серо-графитовый
//
//            default:
//                return UIColor.label.withAlphaComponent(isDark ? 0.8 : 0.7)
//            }
//        }
//    }
//
//    static func nameLabelColor(for background: UIColor) -> UIColor {
//        return UIColor { trait in
//            let isDark = (trait.userInterfaceStyle == .dark)
//
//            switch background {
//            case C.Cards.selectedBlue:
//                return isDark
//                ? UIColor(red: 0.50, green: 0.67, blue: 0.88, alpha: 1.0) // #80ABDFFF
//                : UIColor(red: 0.22, green: 0.33, blue: 0.52, alpha: 1.0) // #385483
//
//            case C.Cards.sourLemon:
//                return isDark
//                ? UIColor(red: 0.90, green: 0.82, blue: 0.55, alpha: 1.0) // #B79E45
//                : UIColor(red: 0.39, green: 0.33, blue: 0.07, alpha: 1.0) // #645411
//
//            case C.Cards.waterfall:
//                return isDark
//                ? UIColor(red: 0.38, green: 0.70, blue: 0.69, alpha: 1.0) // #61B3AF
//                : UIColor(red: 0.09, green: 0.33, blue: 0.32, alpha: 1.0) // #165352
//
//            case C.Cards.innuendo:
//                return isDark
//                ? UIColor(red: 0.63, green: 0.66, blue: 0.72, alpha: 1.0) // #A1A8B7
//                : UIColor(red: 0.25, green: 0.27, blue: 0.32, alpha: 1.0) // #404552
//
//            case C.Cards.customPurple:
//                return isDark
//                ? UIColor(red: 0.63, green: 0.54, blue: 0.76, alpha: 1.0) // #A18AC2
//                : UIColor(red: 0.35, green: 0.27, blue: 0.46, alpha: 1.0) // #594478
//
//            case C.Cards.customGreen:
//                return isDark
//                ? UIColor(red: 0.42, green: 0.67, blue: 0.63, alpha: 1.0) // #6CADA1
//                : UIColor(red: 0.13, green: 0.34, blue: 0.31, alpha: 1.0) // #215752
//
//            case C.Cards.pinkGlamour:
//                return isDark
//                ? UIColor(red: 0.86, green: 0.45, blue: 0.45, alpha: 1.0) // #DB7373
//                : UIColor(red: 0.52, green: 0.09, blue: 0.09, alpha: 1.0) // #841717
//
//            default:
//                return UIColor.label.withAlphaComponent(isDark ? 0.8 : 0.7)
//            }
//        }
//    }
//}

extension C.Cards {

    // MARK: - Title Label Colors (контрастный заголовок)
    static func titleLabelColor(for background: UIColor) -> UIColor {
        return UIColor { trait in
            let isDark = (trait.userInterfaceStyle == .dark)

            switch background {

            case C.Cards.sourLemon:         return isDark ? UIColor(red: 0.95, green: 0.87, blue: 0.52, alpha: 1.0) : UIColor(red: 0.58, green: 0.50, blue: 0.20, alpha: 1.0)
            case C.Cards.innuendo:          return isDark ? UIColor(red: 0.75, green: 0.78, blue: 0.84, alpha: 1.0) : UIColor(red: 0.36, green: 0.39, blue: 0.45, alpha: 1.0)
            case C.Cards.selectedBlue:      return isDark ? UIColor(red: 0.63, green: 0.77, blue: 0.95, alpha: 1.0) : UIColor(red: 0.34, green: 0.49, blue: 0.70, alpha: 1.0)
            case C.Cards.customGrey:        return isDark ? UIColor(red: 0.70, green: 0.77, blue: 0.88, alpha: 1.0) : UIColor(red: 0.32, green: 0.36, blue: 0.42, alpha: 1.0)
            case C.Cards.customYellow:      return isDark ? UIColor(red: 0.93, green: 0.84, blue: 0.47, alpha: 1.0) : UIColor(red: 0.64, green: 0.55, blue: 0.22, alpha: 1.0)
            case C.Cards.customGreen:       return isDark ? UIColor(red: 0.60, green: 0.86, blue: 0.80, alpha: 1.0) : UIColor(red: 0.18, green: 0.46, blue: 0.42, alpha: 1.0)
            case C.Cards.customPurple:      return isDark ? UIColor(red: 0.70, green: 0.60, blue: 0.85, alpha: 1.0) : UIColor(red: 0.47, green: 0.38, blue: 0.55, alpha: 1.0)
            case C.Cards.customBlue:        return isDark ? UIColor(red: 0.65, green: 0.79, blue: 0.96, alpha: 1.0) : UIColor(red: 0.30, green: 0.42, blue: 0.62, alpha: 1.0)
            case C.Cards.customPurpleLight: return isDark ? UIColor(red: 0.78, green: 0.72, blue: 0.88, alpha: 1.0) : UIColor(red: 0.55, green: 0.45, blue: 0.67, alpha: 1.0)
            case C.Cards.waterfall:         return isDark ? UIColor(red: 0.45, green: 0.76, blue: 0.75, alpha: 1.0) : UIColor(red: 0.16, green: 0.46, blue: 0.45, alpha: 1.0)
            case C.Cards.lynxWhite:         return isDark ? UIColor(red: 0.70, green: 0.72, blue: 0.78, alpha: 1.0) : UIColor(red: 0.40, green: 0.42, blue: 0.48, alpha: 1.0)
            case C.Cards.shyMoment:         return isDark ? UIColor(red: 0.66, green: 0.64, blue: 0.95, alpha: 1.0) : UIColor(red: 0.42, green: 0.40, blue: 0.90, alpha: 1.0)
            case C.Cards.fadedPoster:       return isDark ? UIColor(red: 0.60, green: 0.88, blue: 0.88, alpha: 1.0) : UIColor(red: 0.26, green: 0.60, blue: 0.60, alpha: 1.0)
            case C.Cards.cityLights:        return isDark ? UIColor(red: 0.70, green: 0.72, blue: 0.74, alpha: 1.0) : UIColor(red: 0.36, green: 0.38, blue: 0.40, alpha: 1.0)
            case C.Cards.pinkGlamour:       return isDark ? UIColor(red: 0.86, green: 0.45, blue: 0.45, alpha: 1.0) : UIColor(red: 0.52, green: 0.09, blue: 0.09, alpha: 1.0)
            case C.Cards.goldenSend:        return isDark ? UIColor(red: 0.90, green: 0.77, blue: 0.35, alpha: 1.0) : UIColor(red: 0.55, green: 0.46, blue: 0.20, alpha: 1.0)
            case C.Cards.highBlue:          return isDark ? UIColor(red: 0.45, green: 0.65, blue: 0.95, alpha: 1.0) : UIColor(red: 0.20, green: 0.45, blue: 0.70, alpha: 1.0)
            case C.Cards.blueHorizon:       return isDark ? UIColor(red: 0.55, green: 0.65, blue: 0.80, alpha: 1.0) : UIColor(red: 0.18, green: 0.23, blue: 0.33, alpha: 1.0)
            case C.Cards.lightPurple:       return isDark ? UIColor(red: 0.70, green: 0.60, blue: 0.90, alpha: 1.0) : UIColor(red: 0.35, green: 0.25, blue: 0.55, alpha: 1.0)
            case C.Cards.yeuGaungLanBlue:   return isDark ? UIColor(red: 0.45, green: 0.55, blue: 0.80, alpha: 1.0) : UIColor(red: 0.10, green: 0.17, blue: 0.40, alpha: 1.0)
            case C.Cards.goodSamaritan:     return isDark ? UIColor(red: 0.60, green: 0.75, blue: 0.88, alpha: 1.0) : UIColor(red: 0.22, green: 0.30, blue: 0.42, alpha: 1.0)
            case C.Cards.squachBlossom:     return isDark ? UIColor(red: 0.90, green: 0.75, blue: 0.30, alpha: 1.0) : UIColor(red: 0.58, green: 0.45, blue: 0.18, alpha: 1.0)
            case C.Cards.swanWhite:         return isDark ? UIColor(red: 0.80, green: 0.80, blue: 0.72, alpha: 1.0) : UIColor(red: 0.55, green: 0.55, blue: 0.50, alpha: 1.0)
            case C.Cards.rizeNshine:        return isDark ? UIColor(red: 0.88, green: 0.70, blue: 0.28, alpha: 1.0) : UIColor(red: 0.58, green: 0.44, blue: 0.12, alpha: 1.0)
            case C.Cards.vanadylBlue:       return isDark ? UIColor(red: 0.40, green: 0.70, blue: 0.95, alpha: 1.0) : UIColor(red: 0.00, green: 0.36, blue: 0.60, alpha: 1.0)
            case C.Cards.mandariSorbet:     return isDark ? UIColor(red: 0.92, green: 0.65, blue: 0.30, alpha: 1.0) : UIColor(red: 0.70, green: 0.45, blue: 0.12, alpha: 1.0)
            default: return .secondaryLabel
            }
        }
    }

    // MARK: - Name Label Colors (нижние подписи, чуть слабее контраста)
    static func nameLabelColor(for background: UIColor) -> UIColor {
        return UIColor { trait in
            let isDark = (trait.userInterfaceStyle == .dark)

            switch background {

            case C.Cards.sourLemon:         return isDark ? UIColor(red: 0.90, green: 0.82, blue: 0.55, alpha: 1.0) : UIColor(red: 0.39, green: 0.33, blue: 0.07, alpha: 1.0)
            case C.Cards.innuendo:          return isDark ? UIColor(red: 0.63, green: 0.66, blue: 0.72, alpha: 1.0) : UIColor(red: 0.25, green: 0.27, blue: 0.32, alpha: 1.0)
            case C.Cards.selectedBlue:      return isDark ? UIColor(red: 0.50, green: 0.67, blue: 0.88, alpha: 1.0) : UIColor(red: 0.22, green: 0.33, blue: 0.52, alpha: 1.0)
            case C.Cards.customGrey:        return isDark ? UIColor(red: 0.65, green: 0.70, blue: 0.78, alpha: 1.0) : UIColor(red: 0.29, green: 0.32, blue: 0.38, alpha: 1.0)
            case C.Cards.customYellow:      return isDark ? UIColor(red: 0.87, green: 0.78, blue: 0.42, alpha: 1.0) : UIColor(red: 0.42, green: 0.36, blue: 0.09, alpha: 1.0)
            case C.Cards.customGreen:       return isDark ? UIColor(red: 0.42, green: 0.67, blue: 0.63, alpha: 1.0) : UIColor(red: 0.13, green: 0.34, blue: 0.31, alpha: 1.0)
            case C.Cards.customPurple:      return isDark ? UIColor(red: 0.63, green: 0.54, blue: 0.76, alpha: 1.0) : UIColor(red: 0.35, green: 0.27, blue: 0.46, alpha: 1.0)
            case C.Cards.customBlue:        return isDark ? UIColor(red: 0.53, green: 0.69, blue: 0.88, alpha: 1.0) : UIColor(red: 0.25, green: 0.36, blue: 0.54, alpha: 1.0)
            case C.Cards.customPurpleLight: return isDark ? UIColor(red: 0.68, green: 0.62, blue: 0.80, alpha: 1.0) : UIColor(red: 0.43, green: 0.36, blue: 0.56, alpha: 1.0)
            case C.Cards.waterfall:         return isDark ? UIColor(red: 0.38, green: 0.70, blue: 0.69, alpha: 1.0) : UIColor(red: 0.09, green: 0.33, blue: 0.32, alpha: 1.0)
            case C.Cards.lynxWhite:         return isDark ? UIColor(red: 0.55, green: 0.57, blue: 0.63, alpha: 1.0) : UIColor(red: 0.33, green: 0.35, blue: 0.40, alpha: 1.0)
            case C.Cards.shyMoment:         return isDark ? UIColor(red: 0.57, green: 0.55, blue: 0.88, alpha: 1.0) : UIColor(red: 0.33, green: 0.31, blue: 0.77, alpha: 1.0)
            case C.Cards.fadedPoster:       return isDark ? UIColor(red: 0.45, green: 0.75, blue: 0.75, alpha: 1.0) : UIColor(red: 0.20, green: 0.45, blue: 0.45, alpha: 1.0)
            case C.Cards.cityLights:        return isDark ? UIColor(red: 0.57, green: 0.59, blue: 0.62, alpha: 1.0) : UIColor(red: 0.24, green: 0.26, blue: 0.29, alpha: 1.0)
            case C.Cards.pinkGlamour:       return isDark ? UIColor(red: 0.75, green: 0.35, blue: 0.35, alpha: 1.0) : UIColor(red: 0.41, green: 0.07, blue: 0.07, alpha: 1.0)
            case C.Cards.goldenSend:        return isDark ? UIColor(red: 0.75, green: 0.64, blue: 0.26, alpha: 1.0) : UIColor(red: 0.46, green: 0.39, blue: 0.16, alpha: 1.0)
            case C.Cards.highBlue:          return isDark ? UIColor(red: 0.33, green: 0.53, blue: 0.83, alpha: 1.0) : UIColor(red: 0.15, green: 0.35, blue: 0.55, alpha: 1.0)
            case C.Cards.blueHorizon:       return isDark ? UIColor(red: 0.42, green: 0.52, blue: 0.66, alpha: 1.0) : UIColor(red: 0.14, green: 0.19, blue: 0.27, alpha: 1.0)
            case C.Cards.lightPurple:       return isDark ? UIColor(red: 0.55, green: 0.45, blue: 0.75, alpha: 1.0) : UIColor(red: 0.29, green: 0.19, blue: 0.45, alpha: 1.0)
            case C.Cards.yeuGaungLanBlue:   return isDark ? UIColor(red: 0.35, green: 0.45, blue: 0.70, alpha: 1.0) : UIColor(red: 0.08, green: 0.15, blue: 0.33, alpha: 1.0)
            case C.Cards.goodSamaritan:     return isDark ? UIColor(red: 0.50, green: 0.65, blue: 0.78, alpha: 1.0) : UIColor(red: 0.18, green: 0.26, blue: 0.36, alpha: 1.0)
            case C.Cards.squachBlossom:     return isDark ? UIColor(red: 0.80, green: 0.68, blue: 0.25, alpha: 1.0) : UIColor(red: 0.53, green: 0.43, blue: 0.17, alpha: 1.0)
            case C.Cards.swanWhite:         return isDark ? UIColor(red: 0.70, green: 0.70, blue: 0.64, alpha: 1.0) : UIColor(red: 0.48, green: 0.48, blue: 0.44, alpha: 1.0)
            case C.Cards.rizeNshine:        return isDark ? UIColor(red: 0.78, green: 0.62, blue: 0.22, alpha: 1.0) : UIColor(red: 0.48, green: 0.36, blue: 0.10, alpha: 1.0)
            case C.Cards.vanadylBlue:       return isDark ? UIColor(red: 0.30, green: 0.60, blue: 0.88, alpha: 1.0) : UIColor(red: 0.00, green: 0.30, blue: 0.52, alpha: 1.0)
            case C.Cards.mandariSorbet:     return isDark ? UIColor(red: 0.85, green: 0.57, blue: 0.25, alpha: 1.0) : UIColor(red: 0.62, green: 0.40, blue: 0.10, alpha: 1.0)
            default: return .secondaryLabel
            }
        }
    }
}
