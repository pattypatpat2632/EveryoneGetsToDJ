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
    
    func query(artist: String, with token: String) -> Promise<Artist> {
        print("query with token: \(token)")
        return Promise { fulfill, reject in
            let formattedArtist = sanitize(artist)
            let endpoint = "https://api.spotify.com/v1/search?q=\(formattedArtist)&type=artist"
            guard let url = URL(string: endpoint) else {
                reject(ApiError.invalidURL("Invalid URL for getting token"))
                return
            }
            var request = URLRequest(url: url)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET"
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] //TODO: refactor
                        print(json)
                    } catch {
                        reject(ApiError.unexpected("Could not serialize json from data response"))
                    }
                }
            }
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
