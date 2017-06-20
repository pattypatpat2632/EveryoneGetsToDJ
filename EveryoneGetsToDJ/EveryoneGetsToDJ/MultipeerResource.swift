//
//  MultipeerResource.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/19/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

struct MultipeerResource: Serializing {
    enum Method: String {
        case send, remove
    }
    
    var method: Method
    var jukebox: Jukebox
    
    func asDictionary() -> [String: Any]{
        return [
                "method": method.rawValue,
                "jukebox":jukebox.asDictionary()
                ]
    }
}

extension MultipeerResource {
    init(dictionary: [String: Any]) {
        let methodValue = dictionary["method"] as? String ?? ""
        self.method = Method(rawValue: methodValue) ?? .send
        let jukeboxValues = dictionary["jukebox"] as? [String: Any] ?? [:]
        let id = jukeboxValues["id"] as? String ?? ""
        let newJukebox = Jukebox(id: id, dictionary: jukeboxValues)
        self.jukebox = newJukebox
        
    }
}
