//
//  TrackCell.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/21/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell, DJView {
    
    
    @IBOutlet weak var trackNameLabel: DJLabel!
    @IBOutlet weak var artistNameLabel: DJLabel!
    
    var track: Track? {
        didSet {
            if let track = self.track{
                trackNameLabel.text = track.name
                artistNameLabel.text = track.artistName
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setProperties()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TrackCell {
    func setProperties() {
        self.backgroundColor = colorScheme.model.backgroundColor
        self.contentView.layer.borderWidth = 5
        contentView.layer.borderColor = colorScheme.model.foregroundColor.cgColor
        contentView.layer.cornerRadius = 2
    }
}
