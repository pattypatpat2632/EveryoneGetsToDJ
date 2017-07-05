//
//  SelectionsLeftLabel.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/25/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import UIKit

class SelectionsLeftView: UIView {
    
    
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
    
}
