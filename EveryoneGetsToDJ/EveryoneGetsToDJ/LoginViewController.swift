//
//  LoginViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/7/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    let apiClient = ApiClient.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFirstLogin), name: Notification.Name(rawValue: "loginSuccessfull"), object: nil)
        
    }
    
    func setup() {
        SPTAuth.defaultInstance().clientID = clientID
        SPTAuth.defaultInstance().redirectURL = URL(string: redirectURI)
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        print("login tapped")
        UIApplication.shared.open(loginUrl!, options: [:]) { (success) in
            if success {
                if self.auth.canHandle(self.auth.redirectURL) {
                    // TODO: error handling
                }
            }
        }
    }
    
    @IBAction func getTokenTapped(_ sender: UIButton) {
        apiClient.getToken().then { token in
            self.apiClient.query(artist: "Green day", with: token)
        }
    }
    
    func updateAfterFirstLogin() {
        print("updating fter first login")
        
        let sessionObj: AnyObject = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject
        let sessionDataObj = sessionObj as! Data
        let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
        self.session = firstTimeSession
        initializePlayer(authSession: session)
        
    }
    
    func initializePlayer(authSession:SPTSession){
        print("player initialized")
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
            audioStreamingDidLogin(self.player)
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("audio streaming")
        self.player?.playSpotifyURI("spotify:track:6L89mwZXSOwYl76YXfX13s", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }
    
}
