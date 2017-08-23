//
//  PauseButton.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/22/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class PauseButton: DJButton {
    
    var pauseState: PauseState = .playing {
        didSet {
            updateLabel(to: pauseState)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle(as: "||", size: 24)
    }
    
    func updateLabel(to pauseState: PauseState){
        switch pauseState {
        case .paused:
            self.setTitle(as: ">", size: 24)
        case .playing:
            self.setTitle(as: "||", size: 24)
        }
    }
    
    func changeState() {
        switch pauseState {
        case .paused:
            self.pauseState = .playing
        case .playing:
            self.pauseState = .paused
        }
    }
}


enum PauseState {
    case paused, playing
}

