//
//  LoginViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/7/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit
import PromiseKit

class LoginViewController: UIViewController {
    
    let apiClient = ApiClient.sharedInstance
    let loginManager = LoginManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFirstLogin), name: Notification.Name(rawValue: "loginSuccessfull"), object: nil)
        loginManager.setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
    
}
