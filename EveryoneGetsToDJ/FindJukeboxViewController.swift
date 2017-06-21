//
//  FindJukeboxViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/19/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class FindJukeboxViewController: UIViewController {

    let multipeerManager = MultipeerManager.sharedInstance
    let firManager = FirebaseManager.sharedInstance
    var selectedJukebox: Jukebox?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: DJTextField!
    
    override func viewDidLoad() {
        multipeerManager.delegate = self
        self.multipeerManager.startAdvertising()
    }
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        guard let selectedJukebox = selectedJukebox else {return} //TODO: user indicators
        guard textField.isNotEmpty() else {return}
        firManager.set(username: textField.text)
        firManager.observe(jukebox: selectedJukebox.id).then {_ in 
            self.performSegue(withIdentifier: "joinJukeboxSegue", sender: nil)
        }.catch{_ in
            
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

}

extension FindJukeboxViewController: MultipeerManagerDelegate {
    func updateAvailablePeers() {
        tableView.reloadData()
    }
}

extension FindJukeboxViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return multipeerManager.availableJukeboxes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jukeboxCell", for: indexPath) as! JukeboxCell
        cell.jukebox = multipeerManager.availableJukeboxes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedJukebox = multipeerManager.availableJukeboxes[indexPath.row]
    }
}
