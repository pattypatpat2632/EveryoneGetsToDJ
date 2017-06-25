//
//  PlaybackViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/14/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class PlaybackViewController: UIViewController {
    
    
    
    let loginManager = LoginManager.sharedInstance
    let multipeerManager = MultipeerManager.sharedInstance
    let firManager = FirebaseManager.sharedInstance
    let playbackEngine = PlaybackEngine()
    

    @IBOutlet weak var tracksTableView: DJTableView!
    @IBOutlet weak var pauseButton: PauseButton!
    
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
        print("exit tapped")
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
            cell.diskView.animate()
            cell.highlight()
        } else {
            cell.diskView.stopAnimation()
            cell.stopHighlight()
        }
        return cell
    }
}

extension PlaybackViewController: PlaybackEngineDelegate {
    func updatedTracks() {
        tracksTableView.reloadData()
    }
}


