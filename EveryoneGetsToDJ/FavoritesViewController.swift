//
//  FavoritesViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 7/12/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.


import UIKit

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
        let imageActivityIndicator = favoriteCell.trackContentView.activityIndicator
        guard let imageUrl = favoriteCell.track?.imageURL else {return}
        if let url = URL(string: imageUrl) {
            let imageResource = Resource<UIImage>(url: url) { data -> UIImage in
                if let image = UIImage(data: data) {
                    return image
                } else {
                    return #imageLiteral(resourceName: "playingDisk")
                }
            }
            apiClient.getToken().then { token in
                self.apiClient.fetch(resource: imageResource, with: token)
                }.then { image -> Void in
                    imageActivityIndicator?.stopAnimating()
                    favoriteCell.trackContentView.set(image: image)
                }.catch { error in
                    print(error.localizedDescription)
                    imageActivityIndicator?.stopAnimating()
                    favoriteCell.trackContentView.set(image: #imageLiteral(resourceName: "playingDisk"))
            }
        } else {
            imageActivityIndicator?.stopAnimating()
            favoriteCell.trackContentView.set(image: #imageLiteral(resourceName: "playingDisk"))
        }
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
