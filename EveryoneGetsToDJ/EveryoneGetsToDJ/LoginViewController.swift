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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFirstLogin), name: Notification.Name(rawValue: "loginSuccessfull"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setup() {
        SPTAuth.defaultInstance().clientID = clientID
        SPTAuth.defaultInstance().redirectURL = URL(string: clientSecret)
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                // TODO: error handling
            }
        }
    }
    
    func updateAfterFirstLogin () {
        if let sessionObj: AnyObject = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject{
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(authSession: session)
        }
    }
    
        func initializePlayer(authSession:SPTSession){
            if self.player == nil {
                self.player = SPTAudioStreamingController.sharedInstance()
                self.player!.playbackDelegate = self
                self.player!.delegate = self
                try! player!.start(withClientId: auth.clientID)
                self.player!.login(withAccessToken: authSession.accessToken)
            }
        }
        
}
