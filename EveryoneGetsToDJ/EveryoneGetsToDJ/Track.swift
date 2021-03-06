//
//  Track.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/9/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import Firebase

struct Track { 
    //TODO: refactor album and artist into their own structs
    let name: String
    let albumID: String
    let albumName: String
    var artistID: String = ""
    var artistName: String = ""
    var imageURL: String?
    var image: UIImage?
    let uri: String
    var selectorName = "none"
    var selectorID = "none"
    var selectedDate: Date?
}
//MARK: initializers
extension Track {
    init(_ dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.uri = dictionary["uri"] as? String ?? ""
        let artistArray = dictionary["artists"] as? [[String: Any]] ?? []
        if let artistsDictionary = dictionary["artists"] as? [String: Any]{
            self.artistName = artistsDictionary["artistName"] as? String ?? "No Artist Name"
            self.artistID = artistsDictionary["id"] as? String ?? "No ID"
        }
        
        for artist in artistArray {
            let name = artist["name"] as? String ?? "No Name"
            self.artistName = self.artistName + "\(name) "
            self.artistID = artist["id"] as? String ?? "No ID"
        }
        let albumDict = dictionary["album"] as? [String: Any] ?? [:]
        self.albumName = albumDict["name"] as? String ?? "No name"
        self.albumID = albumDict["id"] as? String ?? "No ID"
        
        if let images = albumDict["images"] as? [[String: Any]] {
            for image in images {
                let imageHeight = image["height"] as? Int
                if imageHeight == 64 {
                    self.imageURL = image["url"] as? String
                }
            }
        }
        
        self.selectorID = dictionary["selectorID"] as? String ?? "none"
        if let selectorName = dictionary["selectorName"] as? String{
            self.selectorName = selectorName
        }
        if let selectedDate = dictionary["selectedDate"] as? Double {
            self.selectedDate = Date(timeIntervalSince1970: selectedDate)
        }
        
    }
    
    init?(coreDataTrack: FavoriteTrack) {
        if let name = coreDataTrack.name, let albumID = coreDataTrack.albumID, let albumName = coreDataTrack.albumName, let artistID = coreDataTrack.artistID, let artistName = coreDataTrack.artistName, let uri = coreDataTrack.uri, let imageURL = coreDataTrack.imageURL {
            self.name = name
            self.albumID = albumID
            self.albumName = albumName
            self.artistID = artistID
            self.artistName = artistName
            self.imageURL = imageURL
            self.uri = uri
        } else {
            return nil
        }
    }
}
//MARK: database storage functions
extension Track {
    private mutating func tag() {
        if let username = FirebaseManager.sharedInstance.username {
            self.selectorName = username
        }
        selectorID = FirebaseManager.sharedInstance.uid
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
            "selectorName": selectorName,
            "selectedDate": selectedDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970,
            "selectorID": selectorID
        ]
        return dictionary
    }
}
