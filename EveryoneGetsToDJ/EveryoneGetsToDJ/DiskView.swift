//
//  DiskView.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/25/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class DiskView: UIView, DJView {
    
    @IBOutlet weak var label: DJLabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isHidden = true
        self.backgroundColor = colorScheme.model.backgroundColor
        
    }
    
    func animate() {
        
        UIView.animate(withDuration: 0.2) { 
            self.isHidden = false
            
        }
    }

}
