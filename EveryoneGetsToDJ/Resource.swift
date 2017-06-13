//
//  Resource.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/13/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

struct Resource<T> {
    let url: URL
    let parse: (Data) -> T
}

