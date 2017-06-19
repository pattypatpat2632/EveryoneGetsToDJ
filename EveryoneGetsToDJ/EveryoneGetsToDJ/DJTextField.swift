//
//  DJTextField.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/19/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class DJTextField: UITextField {

    func isEmpty() -> Bool {
        return text == nil || text == ""
    }
    
    func isNotEmpty() -> Bool {
        return !isEmpty()
    }

}
