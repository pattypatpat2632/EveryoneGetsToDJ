//
//  DJTableView.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/23/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class DJTableView: UITableView, DJView {
    var viewCopy: UIView?


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = colorScheme.model.baseColor
    }

}
