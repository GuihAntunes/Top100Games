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

public func startLoading(view : UIView) {
    
    showActivity.center = CGPoint(x: view.center.x, y: view.center.y)
    showActivity.color = UIColor.white
    view.addSubview(showActivity)
    view.bringSubview(toFront: showActivity)
    showActivity.startAnimating()
    
}

public func stopLoading() {
    
    showActivity.stopAnimating()
    showActivity.removeFromSuperview()
    
}

public func createAlertWith(title : String, message : String, retryAction : Bool, _ completion : ((UIAlertAction) -> Void)?) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: LocalizableStrings.okActionTitle.localize(), style: .default, handler: nil)
    alert.addAction(okAction)
    if retryAction {
        let retryAction = UIAlertAction(title: LocalizableStrings.tryAgainTitle.localize(), style: .default, handler: completion)
        alert.addAction(retryAction)
    }
    return alert
}

public func createBlackGradientLayer(forFrame frame : CGRect) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    let newFrame = CGRect(x: frame.minX - 100, y: frame.minY - 100, width: frame.width + 200.0, height: frame.height + 100.0)
    gradientLayer.frame = newFrame
    gradientLayer.locations = [0, 1]
    
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
