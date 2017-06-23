//
//  DJLabel.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/21/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class DJLabel: UILabel, DJView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        textColor = colorScheme.model.foregroundColor
    }
}
