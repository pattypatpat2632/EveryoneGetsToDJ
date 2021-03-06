//
//  FirebaseManager.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/18/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import PromiseKit

final class FirebaseManager {
    
    static let sharedInstance = FirebaseManager()
    let ref = Database.database().reference()
    let jukeRef = Database.database().reference().child("jukeboxes")
    typealias JukeboxID = String
    var username: String?
    
    var jukebox: Jukebox?
    
    var uid: String {
        if let firUser = Auth.auth().currentUser {
            return firUser.uid
        } else {
            return "No ID"
        }
    }
    
    private init() {}
    
    func login() -> Promise<String> {
        return Promise {fulfill, reject in
            Auth.auth().signInAnonymously() { (firUser, error) in
                if let firUser = firUser {
                    fulfill(firUser.uid)
                } else {
                    reject(ApiError.unexpected("Could not log in to Firebase"))
                }
            }
        }
    }
    
    func set(username: String?) {
        self.username = username
    }
    
    func createJukebox(named name: String?) -> Promise<JukeboxID>  {
        return Promise{fulfill, reject in
            if let name = name {
                let newID = ref.child("jukeboxes").childByAutoId().key
                let newJukebox = Jukebox(id: newID, creatorID: FirebaseManager.sharedInstance.uid, name: name, tracks: [])
                ref.child("jukeboxes").child(newID).setValue(newJukebox.asDictionary())
                fulfill(newID)
            } else {
                reject(ApiError.unexpected("Invalid jukebox name"))
            }
        }
    }
    
    func add(track: Track, toJukebox jukeboxID: JukeboxID) {
        var trackCopy = track
        let values = trackCopy.asDictionary()
        jukeRef.child(jukeboxID).child("tracks").child(track.uri).updateChildValues(values)
    }
    
    func remove(track: Track, fromJukebox jukebox: Jukebox) {
        
        jukeRef.child(jukebox.id).child("tracks").child(track.uri).removeValue()
        
    }
    
    func observe(jukebox jukeboxID: JukeboxID) -> Promise<Jukebox> {
        return Promise {fulfill, reject in
            jukeRef.child(jukeboxID).observe(.value, with: { (snapshot) in
                if let snapshotValue = snapshot.value as? [String: Any] {
                    let newJukebox = Jukebox(id: jukeboxID, dictionary: snapshotValue)
                    self.jukebox = newJukebox
                    fulfill(newJukebox)
                    NotificationCenter.default.post(name: .tracksUpdated, object: nil)
                } else {
                    reject(ApiError.unexpected("Could not get jukebox from firebase"))
                }
            })
        }
    }
}

