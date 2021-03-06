//
//  ColorScheme.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/20/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

struct ColorSchemeModel {
    let baseColor: UIColor
    let backgroundColor: UIColor
    let highlightColor: UIColor
    let foregroundColor: UIColor
}

enum ColorScheme {
    case bold, shadowy
    
    var model: ColorSchemeModel {
        switch self {
        case .bold:
            return ColorSchemeModel(baseColor: UIColor.night, backgroundColor: UIColor.pearl, highlightColor: UIColor.flash, foregroundColor: UIColor.phoneBoothRed)
        case .shadowy:
            return ColorSchemeModel(baseColor: UIColor.brownishGray, backgroundColor: UIColor.crepe, highlightColor: UIColor.slate, foregroundColor: UIColor.neonRed)
        }
        
    }
}

extension UIColor {
    open class var night: UIColor {
        return UIColor(displayP3Red: 0, green: 11/255, blue: 41/255, alpha: 1)
    }
    
    open class var phoneBoothRed: UIColor {
        return UIColor(displayP3Red: 215/255, green: 0, blue: 38/255, alpha: 1)
    }
    
    open class var pearl: UIColor {
        return UIColor(displayP3Red: 248/255, green: 245/255, blue: 242/255, alpha: 1)
    }
    
    open class var flash: UIColor {
        return UIColor(displayP3Red: 237/255, green: 184/255, blue: 61/255, alpha: 1)
    }
    
    open class var slate: UIColor {
        return UIColor(displayP3Red: 38/255, green: 47/255, blue: 52/255, alpha: 1)
    }
    
    open class var neonRed: UIColor {
        return UIColor(displayP3Red: 243/255, green: 74/255, blue: 74/255, alpha: 1)
    }
    
    open class var crepe: UIColor {
        return UIColor(displayP3Red: 241/255, green: 211/255, blue: 188/255, alpha: 1)
    }
    
    open class var brownishGray: UIColor {
        return UIColor(displayP3Red: 97/255, green: 80/255, blue: 73/255, alpha: 1)
    }
}
