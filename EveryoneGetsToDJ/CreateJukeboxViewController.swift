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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            //TODO: error handle
        }
        
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        hideKeyboardWhenTappedAround()
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
        guard textField.isNotEmpty() else {return} //TODO: indicate to user that textfields are empty
        guard userTextField.isNotEmpty() else {return}//TODO: indicate to user that textfields are empty
        firManager.set(username: userTextField.text)
        firManager.createJukebox(named: textField.text!).then { jukeboxID in //TODO: refactor force unwrap
            return self.firManager.observe(jukebox: jukeboxID)
        }.then(on: DispatchQueue.main) {_ in
            self.performSegue(withIdentifier: "hostJukeboxSegue", sender: nil)
        }.catch{ error in
                print(error.localizedDescription)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
    }
    
}
