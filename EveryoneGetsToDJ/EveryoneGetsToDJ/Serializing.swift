//
//  Serializing.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/19/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

protocol Serializing {
    func asDictionary() -> [String: Any]
    func asData() -> Data?
}

extension Serializing {
    func asData() -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self.asDictionary(), options: [])
            return data
        } catch {
            return nil
        }
    }
}
