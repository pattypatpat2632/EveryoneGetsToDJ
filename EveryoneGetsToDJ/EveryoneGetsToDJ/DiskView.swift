//
//  DiskView.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/25/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit
import SpriteKit

class DiskView: SKView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.isHidden = true
    }
    
    override func display() {
        super.display()
        let scene = SKScene(fileNamed: "DiskScene")
        self.presentScene(scene)
    }
    
}
