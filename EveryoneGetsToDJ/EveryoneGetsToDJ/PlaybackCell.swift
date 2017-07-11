//
//  PlaybackCell.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/21/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class PlaybackCell: UITableViewCell {

    @IBOutlet weak var titleLabel: DJLabel!
    @IBOutlet weak var artistLabel: DJLabel!
    @IBOutlet weak var userLabel: DJLabel!
    @IBOutlet weak var diskView: DiskView!
 
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
        commonInit()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //overridden to prevent any selection animations
    }
}

extension PlaybackCell {
    func commonInit() {
        self.backgroundColor = colorScheme.model.backgroundColor
        self.layer.borderColor = colorScheme.model.foregroundColor.cgColor
        self.layer.borderWidth = 5
        self.layer.cornerRadius = 2
    }
//TODO: pretty sure I'm not using these functions anymore - check if depracated
    func highlight() {
        self.backgroundColor = colorScheme.model.highlightColor
    }
    
    func stopHighlight() {
        self.backgroundColor = colorScheme.model.backgroundColor
    }
}
