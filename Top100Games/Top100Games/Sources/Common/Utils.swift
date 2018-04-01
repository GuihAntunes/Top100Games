//
//  Utils.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation
import UIKit

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
