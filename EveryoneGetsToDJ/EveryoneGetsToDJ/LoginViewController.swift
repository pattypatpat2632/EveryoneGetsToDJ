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
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFirstLogin), name: Notification.Name(rawValue: "loginSuccessfull"), object: nil)
        loginManager.setup()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        loginManager.login()
    }
    
    func updateAfterFirstLogin() {
        loginManager.updateAfterFirstLogin()
        let djTabBarController = DJTabBarController()
        let playbackVC = PlaybackViewController()
        let selectionVC = SelectionViewController()
        djTabBarController.setViewControllers([playbackVC, selectionVC], animated: true)
        djTabBarController.selectedIndex = 0
        present(djTabBarController, animated: true, completion: nil)
    }
    
    @IBAction func getTokenTapped(_ sender: UIButton) {
        apiClient.getToken().then { token in
            return self.apiClient.query(input: "Green Day", with: token)
        }.then(on: DispatchQueue.main) { (response) -> () in
                print("Response to VC: \(response)")
        }.catch {error in
              print(error.localizedDescription)
        }
        
    }
    
}
