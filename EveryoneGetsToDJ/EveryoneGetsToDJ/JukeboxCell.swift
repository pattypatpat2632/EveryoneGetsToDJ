//
//  JukeboxCell.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/19/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class JukeboxCell: UITableViewCell, DJView {
    
    var viewCopy: UIView?
    
    @IBOutlet weak var nameLabel: DJLabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = colorScheme.model.backgroundColor
        contentView.backgroundColor = UIColor.clear
        self.viewCopy = self
        
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
            flash()
        }
    }
    
}
