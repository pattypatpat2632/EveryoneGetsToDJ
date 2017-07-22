//
//  UIViewExt.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/28/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

extension UIView: DJView {
    
    func flash() {
        
        let bgColor = self.backgroundColor
        UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                self.backgroundColor = self.colorScheme.model.highlightColor
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                self.backgroundColor = bgColor
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2, animations: {
                self.backgroundColor = self.colorScheme.model.highlightColor
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2, animations: {
                self.backgroundColor = bgColor
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4, animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }, completion: nil)
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func display() {
        self.isHidden = false
    }
}

extension UIView {
    public func addInnerShadow(topColor: UIColor = UIColor.black.withAlphaComponent(0.3), bottomColor: UIColor = UIColor.white.withAlphaComponent(0)) {
        let topLayer = CAGradientLayer()
        topLayer.cornerRadius = layer.cornerRadius
        topLayer.frame = bounds
        topLayer.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        topLayer.endPoint = CGPoint(x: 0.5, y: 0.1)
        
        let bottomLayer = CAGradientLayer()
        bottomLayer.cornerRadius = layer.cornerRadius
        bottomLayer.frame = bounds
        bottomLayer.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        bottomLayer.startPoint = CGPoint(x: 0.5, y: 1)
        bottomLayer.endPoint = CGPoint(x: 0.5, y: 0.9)
        
        let leftLayer = CAGradientLayer()
        leftLayer.cornerRadius = layer.cornerRadius
        leftLayer.frame = bounds
        leftLayer.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        leftLayer.startPoint = CGPoint(x: 0, y: 0.5)
        leftLayer.endPoint = CGPoint(x: 0.025, y: 0.5)
        
        let rightLeyer = CAGradientLayer()
        rightLeyer.cornerRadius = layer.cornerRadius
        rightLeyer.frame = bounds
        rightLeyer.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        rightLeyer.startPoint = CGPoint(x: 1, y: 0.5)
        rightLeyer.endPoint = CGPoint(x: 0.975, y: 0.5)
        
        
        layer.addSublayer(topLayer)
        layer.addSublayer(bottomLayer)
        layer.addSublayer(rightLeyer)
        layer.addSublayer(leftLayer)
    }
}

