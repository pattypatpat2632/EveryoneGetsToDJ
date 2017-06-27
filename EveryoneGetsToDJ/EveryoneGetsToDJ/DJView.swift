//
//  DJView.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/20/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

protocol DJView {
    var colorScheme: ColorScheme {get}
    var viewCopy: UIView? {get set}
    
    func hide()
    func display()
    
    func flash()
}

extension DJView {
    var colorScheme: ColorScheme {
        get {
            return .shadowy
        }
    }
    
    func hide() {
        
    }
    
    func display() {
        
    }
    
    //In order to use the flash function, set viewCopy equal to the view you'd like to flash
    func flash() {
        if let viewCopy = viewCopy {
        let bgColor = viewCopy.backgroundColor
            UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: .calculationModeLinear, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                    viewCopy.backgroundColor = self.colorScheme.model.highlightColor
                })
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                    viewCopy.backgroundColor = bgColor
                })
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2, animations: {
                    viewCopy.backgroundColor = self.colorScheme.model.highlightColor
                })
                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2, animations: {
                    viewCopy.backgroundColor = bgColor
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                    viewCopy.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4, animations: {
                    viewCopy.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }, completion: nil)
        
        }
    }
}
