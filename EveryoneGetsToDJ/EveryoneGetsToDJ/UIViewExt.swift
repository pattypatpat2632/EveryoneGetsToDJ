//
//  UIViewExt.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/28/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

extension UIView: DJView {
    
    func flash() {
        
        let bgColor = self.backgroundColor
        UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                self.backgroundColor = self.colorScheme.model.highlightColor
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                self.backgroundColor = bgColor
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2, animations: {
                self.backgroundColor = self.colorScheme.model.highlightColor
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2, animations: {
                self.backgroundColor = bgColor
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4, animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }, completion: nil)
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func display() {
        self.isHidden = false
    }
}


