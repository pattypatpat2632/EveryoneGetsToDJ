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
    let firManager = FirebaseManager.sharedInstance
    var tracks = [Track]()
    @IBOutlet weak var tracksTableVIew: UITableView!
    
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
        firManager.delegate = self
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

extension PlaybackViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playbackCell", for: indexPath)
        return cell
    }
}

extension PlaybackViewController: FirebaseManagerDelegate {
    func tracksUpdated() {
        if let tracks = firManager.jukebox?.tracks{
            let sortedTracks = tracks.sorted(by: { (track0, track1) -> Bool in
                if let date0 = track0.selectedDate, let date1 = track1.selectedDate {
                    return date0 < date1
                } else {
                    return true
                }
            })
            self.tracks = sortedTracks
            tracksTableVIew.reloadData()
        }
    }
}
