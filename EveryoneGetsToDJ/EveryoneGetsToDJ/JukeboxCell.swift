//
//  JukeboxCell.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/19/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class JukeboxCell: UITableViewCell, DJView {
    
    @IBOutlet weak var nameLabel: DJLabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = colorScheme.model.backgroundColor
        contentView.backgroundColor = colorScheme.model.backgroundColor
        
    }

    var jukebox: Jukebox? {
        didSet{
            if let name = jukebox?.name{
                self.nameLabel.text = name
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            self.backgroundColor = colorScheme.model.highlightColor
        } else {
            self.backgroundColor = colorScheme.model.backgroundColor
        }
    }

}
