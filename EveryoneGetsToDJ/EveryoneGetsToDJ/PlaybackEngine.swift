//
//  PlaybackEngine.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/21/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

class PlaybackEngine: NSObject {
    var player: SPTAudioStreamingController?
    let loginManager = LoginManager.sharedInstance
    let firManager = FirebaseManager.sharedInstance
    var tracks = [Track]()
    
    override init() {
        super.init()
        firManager.delegate = self
    }
}

extension PlaybackEngine: SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    func initializePlayer(authSession: SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self //TODO: refactor !
            self.player!.delegate = self
            try! player!.start(withClientId: loginManager.auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    func play(track: Track) {
        player?.playSpotifyURI(track.uri, startingWith: 0, startingWithPosition: 0, callback: { (error) in
          
        })
    }
    
    func set(isPlaying: Bool) {
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
        
    }
}

extension PlaybackEngine: FirebaseManagerDelegate {
    
    func tracksUpdated() {
        if let tracks = firManager.jukebox?.tracks{
            let sortedTracks = tracks.sorted(by: { (track0, track1) -> Bool in
                if let date0 = track0.selectedDate, let date1 = track1.selectedDate {
                    return date0 < date1
                } else {
                    return true
                }
            })
            
            if sortedTracks.count > self.tracks.count { //If tracks were added to jukebox in firebase, add them to the spotify queue
                for i in self.tracks.count..<sortedTracks.count {
                    queue(track: sortedTracks[i])
                }
            }
            self.tracks = sortedTracks
        }
    }
}
