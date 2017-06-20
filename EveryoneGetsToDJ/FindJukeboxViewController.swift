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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        multipeerManager.delegate = self
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
}
