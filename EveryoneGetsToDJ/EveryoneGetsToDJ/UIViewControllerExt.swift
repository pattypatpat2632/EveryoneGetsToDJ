//
//  UIViewControllerExt.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/22/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
