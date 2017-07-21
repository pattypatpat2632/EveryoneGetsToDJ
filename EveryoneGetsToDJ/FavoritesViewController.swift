//
//  FavoritesViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 7/12/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.


import UIKit
import PromiseKit

class FavoritesViewController: UIViewController {
    
    let cdManager = CoreDataManager.sharedInstance
    let firManager = FirebaseManager.sharedInstance
    let apiClient = ApiClient.sharedInstance
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let jukeboxID = firManager.jukebox?.id else {return}
        firManager.add(track: tracks[indexPath.row], toJukebox: jukeboxID)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let favoriteCell = cell as! FavoriteCell
        favoriteCell.set(image: #imageLiteral(resourceName: "playingDisk"))
        if let imageResource = imageResource(from: favoriteCell.track?.imageURL) {
            apiClient.getToken().then{ (token) -> Promise<UIImage> in
                self.apiClient.fetch(resource: imageResource, with: token)
                }.then(on: DispatchQueue.main, execute: { (image) -> Void in
                    favoriteCell.set(image: image)
                }).catch { _ in
                    favoriteCell.set(image: #imageLiteral(resourceName: "playingDisk"))
            }
        }
    }
    
    private func imageResource(from str: String?) -> Resource<UIImage>? {
        guard let urlString = str else {return nil}
        guard let url = URL(string: urlString) else {return nil}
        let imageResource = Resource(url: url) {data -> UIImage in
            if let image = UIImage(data: data) {
                return image
            } else {
                return #imageLiteral(resourceName: "playingDisk")
            }
        }
        return imageResource
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
