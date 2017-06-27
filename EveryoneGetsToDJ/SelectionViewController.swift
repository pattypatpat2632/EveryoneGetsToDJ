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
    let firManager = FirebaseManager.sharedInstance
    var searchActive = false
    var selectionsLeft: Int = 5
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
            }.then { (tracks) -> String in
                self.tracks = tracks
                self.stopActivity()
                return "Done"
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
