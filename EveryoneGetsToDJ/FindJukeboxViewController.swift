//
//  FindJukeboxViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/19/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class FindJukeboxViewController: UIViewController{

    let multipeerManager = MultipeerManager.sharedInstance
    let firManager = FirebaseManager.sharedInstance
    var selectedJukebox: Jukebox?
    var jukeboxes = [Jukebox]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: DJTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        navigationController?.setNavigationBarHidden(false, animated: true)
        multipeerManager.delegate = self
        self.multipeerManager.startAdvertising()
        jukeboxes = multipeerManager.availableJukeboxes
    }
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        guard let selectedJukebox = selectedJukebox else {return} //TODO: user indicators
        guard textField.isNotEmpty() else {return}
        firManager.set(username: textField.text)
        firManager.login().then{_ in 
            self.firManager.observe(jukebox: selectedJukebox.id)
        }.then {_ in
            self.performSegue(withIdentifier: "joinJukeboxSegue", sender: nil)
        }.catch{_ in
            
        }
    }
}

extension FindJukeboxViewController: MultipeerManagerDelegate {
    func updateAvailablePeers() {
        self.jukeboxes = multipeerManager.availableJukeboxes
    }
}

extension FindJukeboxViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jukeboxes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jukeboxCell", for: indexPath) as! JukeboxCell
        cell.jukebox = jukeboxes[indexPath.row]
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedJukebox = jukeboxes[indexPath.row]
    }
}
