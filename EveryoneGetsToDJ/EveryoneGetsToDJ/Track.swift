//
//  Track.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/9/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

struct Track {
    let name: String
    let albumID: String
    let albumName: String
    let artistID: String
    let artistName: String
    var image: UIImage?
    let uri: String
}

extension Track {
    init(_ dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.uri = dictionary["uri"] as? String ?? ""
        let artistDict = dictionary["artists"] as? [String: String] ?? [:]
        self.artistName = artistDict["name"] ?? "No Name"
        self.artistID = artistDict["id"] ?? "No ID"
        let albumDict = dictionary["album"] as? [String: String] ?? [:]
        self.albumName = albumDict["name"] ?? "No name"
        self.albumID = albumDict["id"] ?? "No ID"
    }
}
