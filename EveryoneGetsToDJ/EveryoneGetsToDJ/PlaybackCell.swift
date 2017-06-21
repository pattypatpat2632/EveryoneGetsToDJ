//
//  PlaybackCell.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/21/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class PlaybackCell: UITableViewCell, DJView {
    
    @IBOutlet weak var titleLabel: DJLabel!
    @IBOutlet weak var artistLabel: DJLabel!
    @IBOutlet weak var userLabel: DJLabel!
 
    var track: Track? {
        didSet{
            if let track = self.track {
                titleLabel.text = track.name
                artistLabel.text = track.artistName
                userLabel.text = track.selectorName
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

extension PlaybackCell {
    func setProperties() {
        self.backgroundColor = colorScheme.model.backgroundColor
        self.layer.borderColor = colorScheme.model.foregroundColor.cgColor
        self.layer.borderWidth = 5
        self.layer.cornerRadius = 2
    }
}
