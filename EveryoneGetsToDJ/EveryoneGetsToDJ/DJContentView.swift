//
//  DJContentView.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/22/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class DJContentView: UIView, DJView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = colorScheme.model.baseColor
    }

}
