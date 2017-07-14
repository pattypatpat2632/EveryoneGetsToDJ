//
//  TrackContentView.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 7/12/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class TrackContentView: UIView {

    @IBOutlet var contentView: DJContentView!
    @IBOutlet weak var trackTitleLabel: DJLabel!
    @IBOutlet weak var artistLabel: DJLabel!
    @IBOutlet weak var userLabel: DJLabel!
    @IBOutlet weak var imageView: UIImageView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("TrackContentView", owner: self, options: nil)
        
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
    }
    
    func setLabels(to track: Track) {
        trackTitleLabel.text = track.name
        artistLabel.text = track.artistName
    }
    
    func set(image: UIImage) {
        imageView.image = image
    }

}
