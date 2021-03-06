//
//  DJLabel.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/21/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class DJLabel: UILabel{


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        textColor = colorScheme.model.foregroundColor
        self.backgroundColor = UIColor.clear
    }
}
