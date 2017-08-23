//
//  LoginManager.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/14/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

//Singleton for handling Spotify login
final class LoginManager {
    
    static let sharedInstance = LoginManager()
    
    var loginUrl: URL?
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    
    private init() {}
    
    func setup() {
        SPTAuth.defaultInstance().clientID = clientID
        SPTAuth.defaultInstance().redirectURL = URL(string: redirectURI)
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }
    
    func login() {
        UIApplication.shared.open(loginUrl!, options: [:]) { (success) in
            if success {
                if self.auth.canHandle(self.auth.redirectURL) {
                    // TODO: error handling
                }
            }
        }
    }
    
    func updateAfterFirstLogin() {
        let sessionObj: AnyObject = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject
        let sessionDataObj = sessionObj as! Data
        let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
        self.session = firstTimeSession
    }
}
