//
//  DJButton.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/22/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class DJButton: UIButton{
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        setTitleColor(colorScheme.model.foregroundColor, for: .normal)
        backgroundColor = colorScheme.model.backgroundColor
        layer.borderColor = colorScheme.model.foregroundColor.cgColor
        layer.borderWidth = 5
        layer.cornerRadius = 2
    }
    
    func setTitle(as title: String, size: CGFloat) {
        print("SETTING TITLE")
        let attrs = [
            NSForegroundColorAttributeName: colorScheme.model.foregroundColor,
            NSFontAttributeName: UIFont(name: "Linowrite", size: size)!,
            NSTextEffectAttributeName: NSTextEffectLetterpressStyle as NSString
        ]
        let attTitle = NSAttributedString(string: title, attributes: attrs)
        self.setAttributedTitle(attTitle, for: .normal)
    }
}
