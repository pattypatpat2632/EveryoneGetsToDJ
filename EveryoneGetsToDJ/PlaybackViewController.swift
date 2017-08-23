//
//  PlaybackViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/14/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit
import SpriteKit

class PlaybackViewController: UIViewController {
    
    let loginManager = LoginManager.sharedInstance
    let multipeerManager = MultipeerManager.sharedInstance
    let firManager = FirebaseManager.sharedInstance
    let playbackEngine = PlaybackEngine()
    @IBOutlet weak var exitButton: DJButton!
    @IBOutlet weak var tracksTableView: DJTableView!
    @IBOutlet weak var pauseButton: PauseButton!
    @IBOutlet weak var noTracksPlayingView: NoTracksPlayingView!
    
    var playbackEnabled = false {
        didSet {
            if self.playbackEnabled {
                print("PLAYBACK ENABLED")
                playbackEngine.initializePlayer(authSession: loginManager.session)
                multipeerManager.startBrowsing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playbackEngine.delegate = self
        exitButton.setTitle(as: "EXIT", size: 14)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playbackEngine.tracksUpdated()
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        pauseButton.changeState()
        playbackEngine.set(playback: pauseButton.pauseState)
    }
    
    @IBAction func exitTapped(_ sender: DJButton) {
        navigationController?.popToRootViewController(animated: true)
    }

}

extension PlaybackViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playbackEngine.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playbackCell", for: indexPath) as! PlaybackCell
        cell.track = playbackEngine.tracks[indexPath.row]
        if indexPath.row == 0 {
            cell.diskView.display()
        } else {
            cell.diskView.hide()
        }
        return cell
    }
}

extension PlaybackViewController: PlaybackEngineDelegate {
    func updatedTracks() {
        tracksTableView.reloadData()
        
        if playbackEngine.tracks.isEmpty {
            tracksTableView.isHidden = true
            noTracksPlayingView.display()
        } else {
            tracksTableView.isHidden = false
            noTracksPlayingView.hide()
        }
    }
}


