//
//  DJView.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/20/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

protocol DJView {
    var colorScheme: ColorScheme {get}
}

extension DJView {
    var colorScheme: ColorScheme {
        get {
            return .bold
        }
    }
    
}
