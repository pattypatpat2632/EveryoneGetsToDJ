//
//  ApiClient.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/8/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import PromiseKit

final class ApiClient {
    
    static let sharedInstance = ApiClient()
    
    private init() {}
    
    func getToken() -> Promise<String> {
        return Promise { fulfill, reject in
            let endpoint = "https://accounts.spotify.com/api/token?grant_type=client_credentials"
            guard let url = URL(string: endpoint) else {
                reject(ApiError.invalidURL("Invalid URL for getting token"))
                return
            }
            var request = URLRequest(url: url)
            request.addValue(base64Encode, forHTTPHeaderField: "Authorization")
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] //TODO: refactor
                        let token = json["access_token"] as! String //TODO: refactor
                        fulfill(token)
                    } catch {
                        reject(ApiError.unexpected("Could not serialize json from data response"))
                    }
                }
            }
            task.resume()
        }
    }
    
    func query(input: String, with token: String) -> Promise<([Artist], [Track], [Album])> {
        return Promise { fulfill, reject in
            let artistsResource = artistSearchResource(from: input)!
            let tracksResource = trackSearchResource(from: input)!
            let albumsResource = albumSearchResource(from: input)!
            
            when(fulfilled: fetch(resource: artistsResource, with: token), fetch(resource: tracksResource, with: token), fetch(resource: albumsResource, with: token)).then(execute: { (response) -> Void in
                fulfill(response)
            }).catch(execute: { (error) in
                reject(error)
            })
        }
    }
    
    
    
    func fetch<T>(resource: Resource<T>, with token: String) -> Promise<T> {
        return Promise { fulfill, reject in
            var request = URLRequest(url: resource.url)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, _, _) in
                let response = resource.parse(data!)//TODO: refactor
                fulfill(response)
            })
            task.resume()
        }
    }
    
    func sanitize(_ str: String) -> String {
        let sanitized = str.characters.map { character -> String in
            if character == " " {
                return "+"
            } else {
                return String(character)
            }
            }.joined().lowercased()
        return sanitized
    }
    
    
}
//MARK: resources
extension ApiClient {
    func artistSearchResource(from artist: String) -> Resource<[Artist]>? {
        let formattedArtist = sanitize(artist)
        let endpoint = "https://api.spotify.com/v1/search?q=\(formattedArtist)&type=artist"
        guard let url = URL(string: endpoint) else {return nil}
        let artistsResource = Resource<[Artist]>(url: url, parse: { data in
            var artists = [Artist]()
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                let artistsArray = json["artists"] as? [String: Any] ?? [:]
                let items = artistsArray["items"] as? [[String: Any]] ?? []
                for artistDict in items{
                    let name = artistDict["name"] as? String ?? ""
                    let artist = Artist(name: name, albumIDs: [], trackIDs: [])
                    artists.append(artist)
                }
            } catch {
                
            }
            return artists
        })
        return artistsResource
    }
    
    func albumSearchResource(from album: String) -> Resource<[Album]>? {
        let formattedAlbum = sanitize(album)
        let endpoint = "https://api.spotify.com/v1/search?q=\(formattedAlbum)&type=album"
        guard let url = URL(string: endpoint) else {return nil}
        let albumsResource = Resource<[Album]>(url: url) { data in
            var albums = [Album]()
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                let albumsArray = json["albums"] as? [String: Any] ?? [:]
                let items = albumsArray["items"] as? [[String: Any]] ?? []
                for albumDict in items {
                    let name = albumDict["name"] as? String ?? ""
                    
                    let album = Album(name: name, trackIDs: [], image: nil)
                    albums.append(album)
                }
            } catch {
                
            }
            return albums
        }
        return albumsResource
    }
    
    func trackSearchResource(from track: String) -> Resource<[Track]>? {
        let formattedTrack = sanitize(track)
        let endpoint = "https://api.spotify.com/v1/search?q=\(formattedTrack)&type=track"
        guard let url = URL(string: endpoint) else {return nil}
        let tracksResource = Resource<[Track]>(url: url) { data in
            var tracks = [Track]()
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                let tracksArray = json["tracks"] as? [String: Any] ?? [:]
                let items = tracksArray["items"] as? [[String: Any]] ?? []
                for trackDict in items {
                    let track = Track(trackDict)
                    tracks.append(track)
                }
            } catch {
                
            }
            return tracks
        }
        return tracksResource
    }
}
