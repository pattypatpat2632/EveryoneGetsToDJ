//
//  GlowingLabel.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 7/21/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit
import QuartzCore

class GlowingLabel: DJLabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.shadowColor = colorScheme.model.foregroundColor.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.9
        layer.shadowOffset = CGSize.zero
        layer.masksToBounds = false
    }

}
