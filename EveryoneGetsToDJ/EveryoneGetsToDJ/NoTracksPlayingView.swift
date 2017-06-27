//
//  NoTracksPlayingView.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/27/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class NoTracksPlayingView: UIView, DJView {
    
    @IBOutlet var contentView: DJContentView!
    @IBOutlet weak var label: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("NoTracksPlayingView", owner: self, options: nil)
        
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        contentView.backgroundColor = colorScheme.model.baseColor
        label.textColor = colorScheme.model.foregroundColor
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func display() {
        self.isHidden = false
    }
}
