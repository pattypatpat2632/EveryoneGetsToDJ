//
//  FirebaseManager.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/18/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import Firebase

final class FirebaseManager {
    
    static let sharedInstance = FirebaseManager()
    
    private init() {}
    
    func login() {
        Auth.auth().signInAnonymously() { (firUser, error) in
            // ...
        }
    }
}
