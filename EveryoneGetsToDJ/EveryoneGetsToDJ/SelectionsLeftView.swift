//
//  SelectionsLeftLabel.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/25/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import UIKit

class SelectionsLeftView: UIView, DJView {
    
    @IBOutlet weak var label: DJLabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = colorScheme.model.backgroundColor
        self.layer.borderWidth = 5
        self.layer.borderColor = colorScheme.model.foregroundColor.cgColor
        self.layer.cornerRadius = 2
    }
    
    func updateLabel(withValue value: Int) {
        label.text = "Selections left: \(value)"
    }
    
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
    
}
