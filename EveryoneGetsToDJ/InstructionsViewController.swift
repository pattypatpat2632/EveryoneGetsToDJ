//
//  InstructionsViewController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/23/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController, DJView {
    var viewCopy: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
