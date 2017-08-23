//
//  CoreDataManager.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 7/13/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import CoreData
import PromiseKit

//singleton for CoreData
final class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    var savedTracks = [FavoriteTrack]()
    weak var delegate: CoreDataManagerDelegate?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EveroneGetsToDJ")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                //TODO: handle error
            }
        }
    }
    
    func save(track: Track) {
        let context = persistentContainer.viewContext
        let favoriteTrack = FavoriteTrack(context: context)
        favoriteTrack.name = track.name
        favoriteTrack.albumID = track.albumID
        favoriteTrack.albumName = track.albumName
        favoriteTrack.artistID = track.artistID
        favoriteTrack.artistName = track.artistName
        favoriteTrack.imageURL = track.imageURL
        favoriteTrack.uri = track.uri
        saveContext()
        delegate?.coreDataUpdated()
    }
    
    func delete(track: Track) {//TODO: refactor property exchange
        let context = persistentContainer.viewContext
        for savedTrack in savedTracks {
            if savedTrack.uri == track.uri {
                context.delete(savedTrack)
            }
        }
        saveContext()
        delegate?.coreDataUpdated()
    }
    
    func deleteAllTracks() {
        let context = persistentContainer.viewContext
        savedTracks.forEach{context.delete($0)}
        saveContext()
        delegate?.coreDataUpdated()
    }
    
    func fetchFavoriteTracks() -> Promise<[Track]> {
        print("FETCH FAVORITE TRACKS CALLED")
        return Promise { fulfill, reject in
            let context = persistentContainer.viewContext
            var fetchedTracks = [Track]()
            let fetchRequest : NSFetchRequest<FavoriteTrack> = FavoriteTrack.fetchRequest()
            do {
                let favoriteTracks = try context.fetch(fetchRequest)
                savedTracks = favoriteTracks
                for favoriteTrack in favoriteTracks {
                    if let track = Track(coreDataTrack: favoriteTrack) {
                        fetchedTracks.append(track)
                    }
                }
                fulfill(fetchedTracks)
            } catch {
                reject(ApiError.unexpected("Could not fetch favorite tracks from Core Data"))
            }
        }
    }
}

protocol CoreDataManagerDelegate: class {
    func coreDataUpdated()
}
