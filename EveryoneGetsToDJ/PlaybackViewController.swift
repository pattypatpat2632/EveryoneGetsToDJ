//
//  PlaybackViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/14/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class PlaybackViewController: UIViewController {
    
    var player: SPTAudioStreamingController?
    
    let loginManager = LoginManager.sharedInstance
    let multipeerManager = MultipeerManager.sharedInstance
    var playbackEnabled = false {
        didSet {
            if self.playbackEnabled {
                print("PLAYBACK ENABLED")
                self.initializePlayer(authSession: loginManager.session)
                multipeerManager.startBrowsing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PlaybackViewController: SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: loginManager.auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
            audioStreamingDidLogin(self.player)
        }
    }
    
        func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
            self.player?.playSpotifyURI("spotify:track:6L89mwZXSOwYl76YXfX13s", startingWith: 0, startingWithPosition: 0, callback: { (error) in
                if (error != nil) {
                    print("playing!")
                }
            })
        }
}
