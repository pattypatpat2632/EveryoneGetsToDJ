//
//  SelectionViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/14/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {
    
    @IBOutlet weak var selectionLabel: UILabel!
    let apiClient = ApiClient.sharedInstance
    let firManager = FirebaseManager.sharedInstance
    var searchActive = false
    var selectionsLeft: Int = 5
    
    var artists = [Artist]() {
        didSet {
            DispatchQueue.main.async {
                self.artistTableView.reloadData()
            }
        }
    }
    
    var tracks = [Track]() {
        didSet {
            DispatchQueue.main.async {
                self.trackTableView.reloadData()
            }
        }
    }
    var albums = [Album]() {
        didSet {
            DispatchQueue.main.async {
                self.albumTableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var artistTableView: DJTableView!
    @IBOutlet weak var trackTableView: DJTableView!
    @IBOutlet weak var albumTableView: DJTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(updateSelectionCount), name: .tracksUpdated, object: nil)
        
        artistTableView.isHidden = true
        albumTableView.isHidden = true
    }
    
    func updateSelectionCount() {
        if let tracks = firManager.jukebox?.tracks {
            selectionsLeft = 5 - tracks.filter{$0.selectorID == firManager.uid}.count
            selectionLabel.text = "Selections left: \(selectionsLeft)"
        }
    }
    @IBAction func exitTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

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
        apiClient.getToken().then { token in
            return self.apiClient.query(input: text, with: token)
            }.then { (response) -> String in
                self.artists = response.0
                self.tracks = response.1
                self.albums = response.2
                return ("test")
            }.catch{ error in
                print(error.localizedDescription)
        }
    }
}

extension SelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == artistTableView {
            return artists.count
        } else if tableView == trackTableView {
            return tracks.count
        } else {
            return albums.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == artistTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath)
            cell.backgroundColor = UIColor.red
            return cell
        } else if tableView == trackTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackCell
            cell.track = tracks[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath)
            cell.backgroundColor = UIColor.blue
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard selectionsLeft > 0 else {return} //TODO: indicate no selections left
        if tableView == trackTableView {
            guard let jukeboxID = firManager.jukebox?.id else {return}
            firManager.add(track: tracks[indexPath.row], toJukebox: jukeboxID)
        }
    }
}
