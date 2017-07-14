//
//  FavoritesViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 7/12/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var cdManager = CoreDataManager.sharedInstance
    var tracks = [Track]() {
        didSet {
            print("FAVOITE TRACKS SET: \(tracks.count)***********")
        }
    }
    @IBOutlet weak var tableView: DJTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cdManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coreDataUpdated()
    }
    @IBAction func deleteAllTapped(_ sender: Any) {
        cdManager.deleteAllTracks()
        coreDataUpdated()
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteCell
        cell.set(track: tracks[indexPath.row])
        return cell
    }
}

extension FavoritesViewController: CoreDataManagerDelegate {
    func coreDataUpdated() {
        cdManager.fetchFavoriteTracks().then { savedTracks -> Void in
            self.tracks = savedTracks
            self.tableView.reloadData()
        }.catch { error in
            print("FETCH FaVORITE TRACKS FAILED")
        }
    }
}
