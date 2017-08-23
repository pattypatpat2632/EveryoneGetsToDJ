//
//  CreateJukeboxViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/18/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class CreateJukeboxViewController: UIViewController {
    
    let firManager = FirebaseManager.sharedInstance
    let multipeerManager = MultipeerManager.sharedInstance
    
    @IBOutlet weak var textField: DJTextField!
    @IBOutlet weak var userTextField: DJTextField!
    @IBOutlet weak var createButton: DJButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            //TODO: error handle
        }
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        hideKeyboardWhenTappedAround()
        createButton.setTitle(as: "CREATE JUKEBOX", size: 16)
        FirebaseManager.sharedInstance.login().catch{error in
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! DJTabBarController
        let playbackViewCotnroller = dest.viewControllers?[0] as! PlaybackViewController
        playbackViewCotnroller.playbackEnabled = true
    }
    
    @IBAction func createJukeboxTapped(_ sender: Any) {
        guard textFieldsEntered() else {return}
        firManager.set(username: userTextField.text)
        firManager.createJukebox(named: textField.text!).then { jukeboxID in //TODO: refactor force unwrap
            return self.firManager.observe(jukebox: jukeboxID)
        }.then(on: DispatchQueue.main) {_ in
            self.performSegue(withIdentifier: "hostJukeboxSegue", sender: nil)
        }.catch{ error in
                print(error.localizedDescription)
        }
    }
    
    private func textFieldsEntered() -> Bool { //returns true if all text fields are entered. Otherwise, returns false and indicates to the user which text fields were not filled out
        var textEntered = true
        if textField.isEmpty() {
            textField.flash()
            textEntered = false
        }
        if userTextField.isEmpty() {
            userTextField.flash()
            textEntered = false
        }
        return textEntered
    }
    
}
