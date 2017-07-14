//
//  TrackCell.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/21/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
    
    let trackContentView = TrackContentView()
    let favoriteView = FavoriteView()
    let cdManager = CoreDataManager.sharedInstance
    
    var track: Track? {
        didSet {
            if let track = self.track{
                trackContentView.setLabels(to: track)
                updateFavoritedState()
            }
        }
    }
    
    var favorited = false {
        didSet {
            favoriteView.set(favorited: self.favorited)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setProperties()
        setSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            flash()
        }
    }
    
    func updateFavoritedState() {
        cdManager.fetchFavoriteTracks().then { savedTracks -> Void in
            print("UPDATING FAVORITED STATE FOR TRACK CELL********")
            var favorited = false
            let savedUris = savedTracks.map{$0.uri}
            if let cellTrack = self.track {
                print("CELL HAS A VALID TRACK")
                if savedUris.contains(cellTrack.uri) {
                    print("SAVED URIS DOES CONTAIN CELL TRACK URI*********")
                    favorited = true
                }
            }
            self.favorited = favorited
        }.catch { _ in
                
        }
    }
}

extension TrackCell {
    func setProperties() {
        self.backgroundColor = colorScheme.model.backgroundColor
        self.contentView.layer.borderWidth = 5
        contentView.layer.borderColor = colorScheme.model.foregroundColor.cgColor
        contentView.layer.cornerRadius = 2
    }
    
    func setSubviews() {
        contentView.addSubview(trackContentView)
        trackContentView.translatesAutoresizingMaskIntoConstraints = false
        trackContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        trackContentView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        trackContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        trackContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        
        contentView.addSubview(favoriteView)
        favoriteView.translatesAutoresizingMaskIntoConstraints = false
        favoriteView.leftAnchor.constraint(equalTo: trackContentView.rightAnchor).isActive = true
        favoriteView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        favoriteView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        favoriteView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        favoriteView.backgroundColor = UIColor.green
        favoriteView.delegate = self
    }
}

extension TrackCell: FavoriteViewDelegate {
    func respondToTap() {
        if let track = track {
            if !favorited {
                let savedUris = cdManager.savedTracks.map{$0.uri ?? "NO URI"}
                if !savedUris.contains(track.uri) {
                    cdManager.save(track: track)
                }
                self.favorited = true
            } else {
                if let track = self.track {
                    cdManager.delete(track: track)
                }
                self.favorited = false
            }
        }
    }
}
