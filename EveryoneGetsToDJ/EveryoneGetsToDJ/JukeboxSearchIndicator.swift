//
//  JukeboxSearchIndicator.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/24/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class JukeboxSearchIndicator: DJLabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = colorScheme.model.baseColor
        textColor = colorScheme.model.foregroundColor
        animate()
    }
    
    func animate() {
        let textColor = colorScheme.model.foregroundColor
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .repeat, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                self.textColor = self.colorScheme.model.highlightColor
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                self.textColor = textColor
            })
        }, completion: nil)
    }
}
