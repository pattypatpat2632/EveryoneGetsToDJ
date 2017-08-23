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
    
    @IBOutlet weak var tableView: DJTableView!
    @IBOutlet weak var textField: DJTextField!
    @IBOutlet weak var searchingLabel: JukeboxSearchIndicator!
    @IBOutlet weak var selectionLabel: DJLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicateSearching()
        hideKeyboardWhenTappedAround()
        navigationController?.setNavigationBarHidden(false, animated: true)
        multipeerManager.delegate = self
        self.multipeerManager.startAdvertising()
        jukeboxes = multipeerManager.availableJukeboxes
    }
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        guard textField.isNotEmpty() else {
            textField.flash()
            return
        }
        guard let selectedJukebox = selectedJukebox else {
            noJukeboxAlert()
            return
        }
        join(selectedJukebox)
    }
}

//MARK: multipeer delegate
extension FindJukeboxViewController: MultipeerManagerDelegate {
    func updateAvailablePeers() {
        self.jukeboxes = multipeerManager.availableJukeboxes
    }
}

//MARK: tableview delegate and data source
extension FindJukeboxViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if jukeboxes.count == 0 {
            indicateSearching()
        } else {
            indicateNotSearching()
        }
        return jukeboxes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jukeboxCell", for: indexPath) as! JukeboxCell
        cell.jukebox = jukeboxes[indexPath.row]
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedJukebox = jukeboxes[indexPath.row]
        if let name = selectedJukebox?.name {
            selectionLabel.text = "Selected: \(name)"
        }
    }
}

//MARK: helper functions
extension FindJukeboxViewController {
    fileprivate func noJukeboxAlert() {
        let alert = UIAlertController(title: "No Jukebox Selected", message: "Please select a Jukebox to join", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func join(_ jukebox: Jukebox){
        firManager.set(username: textField.text)
        firManager.login().then{_ in
            self.firManager.observe(jukebox: jukebox.id)
            }.then {_ in
                self.performSegue(withIdentifier: "joinJukeboxSegue", sender: nil)
            }.catch{_ in
                
        }
    }
}

extension FindJukeboxViewController {
    func indicateSearching() {
        searchingLabel.isHidden = false
        tableView.isHidden = true
    }
    
    func indicateNotSearching() {
        searchingLabel.isHidden = true
        tableView.isHidden = false
    }
}
