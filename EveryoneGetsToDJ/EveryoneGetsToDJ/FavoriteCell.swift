//
//  FavoriteCell.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 7/13/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    @IBOutlet weak var trackContentView: TrackContentView!
    
    var track: Track? {
        didSet{
            if let track = track {
                trackContentView.setLabels(to: track)
                
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setProperties()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            flash()
        }
    }
    
    func set(track: Track) {
        self.track = track
    }
    
    func setProperties() {
        self.backgroundColor = colorScheme.model.backgroundColor
        self.contentView.layer.borderWidth = 5
        contentView.layer.borderColor = colorScheme.model.foregroundColor.cgColor
        contentView.layer.cornerRadius = 2
    }
}
