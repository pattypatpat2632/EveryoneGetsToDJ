//
//  DJButton.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/22/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class DJButton: UIButton, DJView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        setTitleColor(colorScheme.model.foregroundColor, for: .normal)
        backgroundColor = colorScheme.model.backgroundColor
        layer.borderColor = colorScheme.model.foregroundColor.cgColor
        layer.borderWidth = 5
        layer.cornerRadius = 2
    }
}
