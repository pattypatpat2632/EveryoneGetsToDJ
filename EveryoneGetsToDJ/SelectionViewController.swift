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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    func getToken() {
        apiClient.getToken().then { token in
            return self.apiClient.query(input: "Green Day", with: token)
            }.then(on: DispatchQueue.main) { (response) -> () in
                print("Response to VC: \(response)")
            }.catch {error in
                print(error.localizedDescription)
        }
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
}

extension SelectionViewController {
    func search(text: String) {
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
