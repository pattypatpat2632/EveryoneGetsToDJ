//
//  instructionsTextView.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/25/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class instructionsTextView: UITextView, DJView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textColor = colorScheme.model.foregroundColor
        self.backgroundColor = colorScheme.model.backgroundColor
        self.layer.borderWidth = 5
        self.layer.borderColor = colorScheme.model.foregroundColor.cgColor
        self.layer.cornerRadius = 2
        setText()
    }
    
    func setText() {
        self.text = "Everyone Gets to DJ!\n\n   To use this app, one person must act as the host. The host's phone will play back all of the music. The host must log in to their Spotify Premium account in order play back any music.\n   When the host has created a jukebox, everyone else on the same Wi-Fi network will be able to select and join that jukebox. Everyone who has joined a jukebox can add up to five songs at a time to the jukebox. A song cannot be added the playlist if its already on the list.\n\n\n   Everyone Gets to DJ was created by Patrick O'Leary. For support or questions, please email patoleary.dev@gmail.com\n\nVersion 1.0\n Disc by Curve from the Noun Project"
    }

}
