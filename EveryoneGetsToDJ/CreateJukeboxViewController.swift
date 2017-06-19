//
//  CreateJukeboxViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/18/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class CreateJukeboxViewController: UIViewController {
    
    @IBOutlet weak var textField: DJTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! DJTabBarController
        
    }
    
    @IBAction func createJukeboxTapped(_ sender: Any) {
        guard textField.isNotEmpty() else {return} //TODO: indicate to user that textfield is empty
        performSegue(withIdentifier: "hostJukeboxSegue", sender: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
    }

}
