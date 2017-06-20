//
//  JukeboxCell.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/19/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class JukeboxCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!

    var jukebox: Jukebox? {
        didSet{
            if let name = jukebox?.name{
                self.nameLabel.text = name
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
