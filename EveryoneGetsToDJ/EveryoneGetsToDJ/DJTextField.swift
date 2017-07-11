//
//  DJTextField.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/19/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class DJTextField: UITextField{
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
       
        layer.borderWidth = 5
        layer.cornerRadius = 2
        layer.borderColor = colorScheme.model.foregroundColor.cgColor
        backgroundColor = colorScheme.model.backgroundColor
        textColor = colorScheme.model.foregroundColor
    }

    func isEmpty() -> Bool {
        return text == nil || text == ""
    }
    
    func isNotEmpty() -> Bool {
        return !isEmpty()
    }
    
}
