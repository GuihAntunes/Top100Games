//
//  Utils.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation
import UIKit

let showActivity = UIActivityIndicatorView()

func startLoading(view : UIView) {
    
    showActivity.center = CGPoint(x: view.center.x, y: view.center.y)
    showActivity.color = UIColor.white
    view.addSubview(showActivity)
    view.bringSubview(toFront: showActivity)
    showActivity.startAnimating()
    
}

func stopLoading() {
    
    showActivity.stopAnimating()
    showActivity.removeFromSuperview()
    
}

public func createBlueGradientLayer(ForFrame frame : CGRect) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.darkBlue.cgColor, UIColor.mediorBlue.cgColor, UIColor.lightBlue.cgColor]
    gradientLayer.frame = frame
    gradientLayer.locations = [0, 0.5, 1]
    
    return gradientLayer
}

public func createRoundedShadowLayer(withFrame frame : CGRect) -> CAShapeLayer {
    let shadowRoundedLayer = CAShapeLayer()
    shadowRoundedLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: 12).cgPath
    shadowRoundedLayer.fillColor = UIColor.white.cgColor
    
    shadowRoundedLayer.shadowColor = UIColor.darkGray.cgColor
    shadowRoundedLayer.shadowPath = shadowRoundedLayer.path
    shadowRoundedLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    shadowRoundedLayer.shadowOpacity = 0.8
    shadowRoundedLayer.shadowRadius = 2
    
    return shadowRoundedLayer
}
