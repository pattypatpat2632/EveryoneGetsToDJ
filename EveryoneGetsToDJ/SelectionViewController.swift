//
//  SelectionViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/14/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {
    
    let apiClient = ApiClient.sharedInstance
    var searchActive = false
    var artists = [Artist]() {
        didSet {
            artists.forEach{print("ARTIST: \($0.name)")}
        }
    }
    var tracks = [Track]() {
        didSet {
            tracks.forEach{print("TRACK: \($0.name)")}
        }
    }
    var albums = [Album]() {
        didSet {
            albums.forEach{print("ALBUM:\($0.name)")}
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var artistTableView: UITableView!
    @IBOutlet weak var trackTableView: UITableView!
    @IBOutlet weak var albumTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
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
                return ("test string")
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
        switch tableView {
        case artistTableView:
            return artists.count
        case trackTableView:
            return tracks.count
        case albumTableView:
            return albums.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
}
