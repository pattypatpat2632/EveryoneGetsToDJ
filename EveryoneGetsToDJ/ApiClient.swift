//
//  ApiClient.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/8/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

final class ApiClient {
    
    static let sharedInstance = ApiClient()
    
    private init() {}
    
    func getToken(completion: @escaping (ApiResponse) -> Void) {
        let endpoint = "https://accounts.spotify.com/api/token?grant_type=client_credentials"
        guard let url = URL(string: endpoint) else {
            completion(.failure("Could not create URL from endpoint string"))
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
                    completion(.success(token))
                } catch {
                    completion(.failure("Return from API did not return valid JSON"))
                }
            }
        }
        task.resume()
    }
    
    func query(_ query: String, with token: String) {
        getToken { (response) in
            
        }
    }
}
