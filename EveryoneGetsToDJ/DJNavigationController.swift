//
//  DJNavigationController.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/22/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class DJNavigationController: UINavigationController, DJView {
    var viewCopy: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.backgroundColor = colorScheme.model.baseColor
    }

}
