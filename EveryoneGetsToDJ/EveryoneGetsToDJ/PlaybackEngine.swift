//
//  PlaybackEngine.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/21/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import AVFoundation

class PlaybackEngine: NSObject {
    var player: SPTAudioStreamingController?
    let loginManager = LoginManager.sharedInstance
    let firManager = FirebaseManager.sharedInstance
    var delegate: PlaybackEngineDelegate?
    var tracks = [Track]() {
        didSet {
            delegate?.updatedTracks()
        }
    }
    
    override init() {
        super.init()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(tracksUpdated), name: .tracksUpdated, object: nil)
    }
}

extension PlaybackEngine: SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    func initializePlayer(authSession: SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self //TODO: refactor !
            self.player!.delegate = self
            do {
                try player!.start(withClientId: loginManager.auth.clientID)
            } catch {
                print("player already initialized")
            }
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    func play(track: Track) {
        player?.playSpotifyURI(track.uri, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            
        })
    }
    
    func set(playback: PauseState) {
        var isPlaying: Bool
        switch playback {
        case .playing:
            isPlaying = true
        case .paused:
            isPlaying = false
        }
        player?.setIsPlaying(isPlaying, callback: { (error) in
            
        })
    }
    
    func queue(track: Track) {
        player?.queueSpotifyURI(track.uri, callback: { (error) in
            
        })
    }
    
    func change(volume: Double) {
        player?.setVolume(volume, callback: { (error) in
            
        })
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
        guard let jukebox = firManager.jukebox else {return}
        firManager.remove(track: tracks[0], fromJukebox: jukebox)
    }
    
    
    
}

extension PlaybackEngine {
    
    func tracksUpdated() {
       
        if let tracks = firManager.jukebox?.tracks{
            let sortedTracks = tracks.sorted(by: { (track0, track1) -> Bool in
                if let date0 = track0.selectedDate, let date1 = track1.selectedDate {
                    return date0 < date1
                } else {
                    return true
                }
            })
            
            if sortedTracks.count > self.tracks.count { //Check to see if there were new tracks added to the jukebox in firebase, and if so add them to the Spotify queue
                for i in self.tracks.count..<sortedTracks.count {
                    if sortedTracks.count == 1 {
                        play(track: sortedTracks[i])
                    } else {
                        queue(track: sortedTracks[i])
                    }
                }
            }
            self.tracks = sortedTracks
        }
    }
}

protocol PlaybackEngineDelegate {
    func updatedTracks()
}
