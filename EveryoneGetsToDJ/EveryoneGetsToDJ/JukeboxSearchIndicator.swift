//
//  JukeboxSearchIndicator.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/24/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class JukeboxSearchIndicator: DJLabel {
    
    var animateStage: CGFloat = 0
    var animateIncrementing = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func animate() {
        if animateStage <= 0 {
            animateIncrementing = true
            animateStage += 0.1
            self.alpha = animateStage
        } else if animateStage >= 1.0 {
            animateIncrementing = false
            animateStage -= 0.1
            self.alpha = animateStage
        } else {
            if animateIncrementing {
                animateStage += 0.1
                self.alpha = animateStage
            } else {
                animateStage -= 0.1
                self.alpha = animateStage
            }
        }
    }
}
