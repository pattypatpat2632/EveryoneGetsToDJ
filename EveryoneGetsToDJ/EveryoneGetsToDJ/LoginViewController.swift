//
//  LoginViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/7/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit
import PromiseKit
import AVFoundation

class LoginViewController: UIViewController {
    
    let apiClient = ApiClient.sharedInstance
    let loginManager = LoginManager.sharedInstance
    @IBOutlet weak var hostButton: DJButton!
    @IBOutlet weak var joinButton: DJButton!
    @IBOutlet weak var instrButton: DJButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFirstLogin), name: .loginSuccessful, object: nil)
        loginManager.setup()
        setTitles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        do {
           try SPTAudioStreamingController.sharedInstance().stop()
        } catch {
            print("Unable to stop spotify streaming controller")
            //TODO: error handling - this probably only fails if user has lost data connection - should alert user to this fact? - according to doc, logout should occur before sharedInstance.stop is called - may be causing crash error
        }
    }
    
    @IBAction func loginTapped(_ sender: DJButton) {
        loginManager.login()
    }
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "joinSegue", sender: nil)
    }
    
    func updateAfterFirstLogin() {
        loginManager.updateAfterFirstLogin()
        self.performSegue(withIdentifier: "hostSegue", sender: nil)
    }
    
    private func setTitles() {
        hostButton.setTitle(as: "HOST", size: 20)
        joinButton.setTitle(as: "JOIN", size: 20)
        instrButton.setTitle(as: "INSTRUCTIONS", size: 12)
    }
    
}
