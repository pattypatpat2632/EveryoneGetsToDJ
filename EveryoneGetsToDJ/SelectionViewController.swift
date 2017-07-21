//
//  SelectionViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/14/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit
import PromiseKit

class SelectionViewController: UIViewController {
    
    
    let apiClient = ApiClient.sharedInstance
    let firManager = FirebaseManager.sharedInstance
    var searchActive = false
    var selectionsLeft: Int = 5
    let imageQueue = OperationQueue()
    
    @IBOutlet weak var activityIndicator: DJActivityIndicatorView!
    @IBOutlet weak var selectionsLeftView: SelectionsLeftView!
    
    var tracks = [Track]() {
        didSet {
            DispatchQueue.main.async {
                self.trackTableView.reloadData()
            }
        }
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var trackTableView: DJTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(updateSelectionCount), name: .tracksUpdated, object: nil)
        
        imageQueue.qualityOfService = .userInitiated
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let visibleCells = trackTableView.visibleCells as! [TrackCell]
        visibleCells.forEach{$0.updateFavoritedState()}
    }
    
    func updateSelectionCount() {
        if let tracks = firManager.jukebox?.tracks {
            selectionsLeft = 5 - tracks.filter{$0.selectorID == firManager.uid}.count
            selectionsLeftView.updateLabel(withValue: selectionsLeft)
        }
    }
    @IBAction func exitTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
//MARK: search bar delegate
extension SelectionViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        print("search active: \(searchActive)")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = true
        print("search active: \(searchActive)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        print("search active: \(searchActive)")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        print("search active: \(searchActive)")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            self.searchActive = false
            print("serch active: \(searchActive)")
        } else {
            self.searchActive = true
            print("serch active: \(searchActive)")
            if let searchText = searchBar.text {
                search(text: searchText)
            }
        }
    }
    
    private func search(text: String) {
        indicateActivity()
        apiClient.getToken().then { token in
            return self.apiClient.query(input: text, with: token)
            }.then { (tracks) -> Void in
                self.tracks = tracks
                self.stopActivity()
            }.catch{ error in
                
        }
    }
}
// MARK: tableview delegate and data source
extension SelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackCell
        cell.track = tracks[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard selectionsLeft > 0 else {
            selectionsLeftView.flash()
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == trackTableView {
            guard let jukeboxID = firManager.jukebox?.id else {return}
            firManager.add(track: tracks[indexPath.row], toJukebox: jukeboxID)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let trackCell = cell as! TrackCell
        if let imageResource = imageResource(from: trackCell.track?.imageURL) {
            apiClient.getToken().then{ (token) -> Promise<UIImage> in
                self.apiClient.fetch(resource: imageResource, with: token)
            }.then(on: DispatchQueue.main, execute: { (image) -> Void in
                trackCell.set(image: image)
            }).catch { _ in
                trackCell.set(image: #imageLiteral(resourceName: "playingDisk"))
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

//MARK: activity indicator
extension SelectionViewController {
    
    fileprivate func indicateActivity() {
        activityIndicator.isHidden = false
        trackTableView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    fileprivate func stopActivity() {
        activityIndicator.stopAnimating()
        trackTableView.isHidden = false
    }
}
