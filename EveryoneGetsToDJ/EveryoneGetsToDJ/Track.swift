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
    var imageURL: String?
    var image: UIImage?
    let uri: String
    var selectorID = "none"
    var selectedDate: Date?
}
//MARK: initializers
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
        
        if let selectorID = dictionary["selectorID"] as? String{
            self.selectorID = selectorID
        }
        if let selectedDate = dictionary["selectedDate"] as? Double {
            self.selectedDate = Date(timeIntervalSince1970: selectedDate)
        }
    }
}
//MARK: database storage functions
extension Track {
    private mutating func tag() {
        self.selectorID = FirebaseManager.sharedInstance.uid
        selectedDate = Date()
    }
    
    mutating func asDictionary() -> [String: Any] {
        self.tag()
        let dictionary: [String: Any] = [
            "name": name,
            "album": ["albumID": albumID,
            "albumName": albumName],
            "artists":["artistID": artistID,
            "artistName": artistName],
            "uri": uri,
            "selectorID": selectorID,
            "selectedDate": selectedDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        ]
        return dictionary
    }
}
