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
        
        backgroundColor = UIColor.clear
        addInnerShadow(topColor: UIColor.black.withAlphaComponent(1), bottomColor: UIColor.clear)
    }

}
