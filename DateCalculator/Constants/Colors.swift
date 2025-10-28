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
            return UIColor(red: 0.33, green: 0.74, blue: 0.97, alpha: 1.0)
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
    
    struct Cards {
        static let selectedBlue = UIColor(red: 0.70, green: 0.84, blue: 1.00, alpha: 0.60) //blue*
        static let innuendo = UIColor(red: 0.65, green: 0.69, blue: 0.76, alpha: 0.30) // grey *
        static let waterfall = UIColor(red: 0.22, green: 0.68, blue: 0.66, alpha: 0.40) //green *
        static let sourLemon = UIColor(red: 1.00, green: 0.92, blue: 0.65, alpha: 1.00) //yellow *
        static let lynxWhite = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 0.20) //light grey
        
        static let shyMoment = UIColor(red: 0.64, green: 0.61, blue: 1.00, alpha: 1.00) //purple
        //static let fadedPoster = UIColor(red: 0.51, green: 0.93, blue: 0.93, alpha: 1.00) //green
        static let cityLights = UIColor(red: 0.87, green: 0.90, blue: 0.91, alpha: 0.40)//grey
        static let pinkGlamour = UIColor(red: 1.00, green: 0.46, blue: 0.46, alpha: 1.00) //red
        static let goldenSend = UIColor(red: 0.93, green: 0.80, blue: 0.41, alpha: 0.70)
        //static let white = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        static let highBlue = UIColor(red: 0.27, green: 0.67, blue: 0.95, alpha: 0.40)
        static let blueHorizon = UIColor(red: 0.29, green: 0.40, blue: 0.52, alpha: 0.20)
        static let lightPurple = UIColor(red: 0.65, green: 0.37, blue: 0.92, alpha: 0.40)
        static let yeuGaungLanBlue = UIColor(red: 0.12, green: 0.22, blue: 0.60, alpha: 0.20)
        static let goodSamaritan = UIColor(red: 0.24, green: 0.39, blue: 0.51, alpha: 0.20)
        static let squachBlossom = UIColor(red: 0.96, green: 0.73, blue: 0.23, alpha: 0.40)
        static let swanWhite = UIColor(red: 0.97, green: 0.95, blue: 0.89, alpha: 0.40)
        static let rizeNshine = UIColor(red: 0.98, green: 0.77, blue: 0.19, alpha: 0.50)
        static let vanadylBlue = UIColor(red: 0.00, green: 0.59, blue: 0.90, alpha: 0.70)
        static let mandariSorbet = UIColor(red: 1.00, green: 0.69, blue: 0.25, alpha: 0.50)
        
    }
}
