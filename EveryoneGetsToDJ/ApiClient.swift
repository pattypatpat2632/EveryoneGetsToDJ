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
    let searchQueue = OperationQueue()
    
    private init() {
        searchQueue.qualityOfService = .userInitiated
    }
    
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
                } else {
                    reject(ApiError.unexpected("Could not get token"))
                }
            }
            task.resume()
        }
    }
    
    func query(input: String, withToken token: String) -> Promise<[Track]> {
        searchQueue.cancelAllOperations()
        return Promise { fulfill, reject in
            let promiseOp = BlockOperation {
                if let tracksResource = self.trackSearchResource(from: input) {
                    self.fetch(resource: tracksResource, with: token).then(execute: { (tracks) in
                        fulfill(tracks)
                    }).catch(execute: { (error) in
                        reject(error)
                    })
                } else {
                    reject(ApiError.unexpected("Invalid track search resource"))
                }
            }
            searchQueue.addOperation(promiseOp)
        }
    }
    
    func fetch<T>(resource: Resource<T>, with token: String) -> Promise<T> { //Fetches instance of a resource
        return Promise { fulfill, reject in
            var request = URLRequest(url: resource.url)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, _, _) in
                if let data = data {
                    let response = resource.parse(data)
                    fulfill(response)
                } else {
                    reject(ApiError.unexpected("No data returned from fetch function")) //TODO: refactor error handling
                }
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
        return (sanitized + "*")
    }
    
    
}
//MARK: resources
extension ApiClient {
    
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
