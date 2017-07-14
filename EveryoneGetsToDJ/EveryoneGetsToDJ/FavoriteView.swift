//
//  FavoriteView.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 7/13/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class FavoriteView: UIView {

    @IBOutlet var contentView: DJContentView!
    @IBOutlet weak var starLabel: UILabel!
    
    weak var delegate: FavoriteViewDelegate?
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("FavoriteView", owner: self, options: nil)
        
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        starLabel.backgroundColor = colorScheme.model.backgroundColor
        
        addGestures()
    }
    
    func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    func viewTapped() {
        delegate?.respondToTap()
    }
    
    func set(favorited: Bool) {
        if favorited {
            starLabel.backgroundColor = colorScheme.model.highlightColor
        } else {
            starLabel.backgroundColor = colorScheme.model.backgroundColor
        }
    }
}

protocol FavoriteViewDelegate: class {
    func respondToTap()
}
