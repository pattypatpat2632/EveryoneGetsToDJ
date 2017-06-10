//
//  ApiError.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/9/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case invalidURL(String)
    case unexpected(String)
}
