//
//  Jukebox.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/19/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

struct Jukebox {
    let id: String
    let creatorID: String
    let name: String
    var tracks = [Track]()
}

extension Jukebox {
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.creatorID = dictionary["creatorID"] as? String ?? "No Creator"
        self.name = dictionary["name"] as? String ?? "No Name"
        let allTracks = dictionary["tracks"] as? [String: Any] ?? [:]
        for track in allTracks {
            let trackValue = track.value as? [String: Any] ?? [:]
            let newTrack = Track(trackValue)
            self.tracks.append(newTrack)
        }
    }
}

extension Jukebox {
    
    func asDictionary() -> [String: Any]{
        
            let dictionary: [String: Any] = [
                "creatorID": FirebaseManager.sharedInstance.uid,
                "name": self.name
            ]
            return dictionary
        
    }
}
