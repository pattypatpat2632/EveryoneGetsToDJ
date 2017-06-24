//
//  DJActivityIndicatorView.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/24/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class DJActivityIndicatorView: UIActivityIndicatorView, DJView {

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.color = colorScheme.model.highlightColor
        self.hidesWhenStopped = true
    }

}
