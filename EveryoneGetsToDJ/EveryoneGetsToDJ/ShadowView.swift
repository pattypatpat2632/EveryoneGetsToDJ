//
//  ShadowView.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 7/21/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = colorScheme.model.baseColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
    }

}
