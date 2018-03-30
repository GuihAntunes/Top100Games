//
//  Extensions.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation
import UIKit
import Reachability

extension Reachability {
    // MARK: - Private Computed Properties
    private static let defaultHost = "www.google.com"
    private static var reachability = Reachability(hostname: defaultHost)
    
    // MARK: - Public Functions
    
    /// True value if there is a stable network connection
    static var isConnected: Bool {
        guard let reachability = Reachability.reachability else { return false }
        
        return reachability.connection != .none
    }
    
    /// Current network status based on enum NetworkStatus
    static var status: Connection {
        guard let reachability = Reachability.reachability else { return .none }
        
        return reachability.connection
    }
}

extension UIColor {
    
    static let twitchPurple = UIColor(red: 50/255, green: 32/255, blue: 99/255, alpha: 1.0)
    
}

extension UIViewController : UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let circularTransition = CircularTransition()
        circularTransition.transitionMode = .present
        circularTransition.startingPoint = view.center
        circularTransition.circleColor = UIColor.twitchPurple
        
        return circularTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let circularTransition = CircularTransition()
        circularTransition.transitionMode = .dismiss
        circularTransition.startingPoint = view.center
        circularTransition.circleColor = UIColor.twitchPurple
        
        return circularTransition
    }
}

extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Identifiable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UIColor {
    
    static let darkBlue = UIColor(red: 54/255, green: 70/255, blue: 121/255, alpha: 1.0)
    
    static let mediorBlue = UIColor(red: 78/255, green: 105/255, blue: 172/255, alpha: 1.0)
    
    static let lightBlue = UIColor(red: 112/255, green: 165/255, blue: 217/255, alpha: 1.0)
    
}

extension CALayer {
    
    public func addShadow() {
        self.shadowOffset = .zero
        self.shadowOpacity = 0.3
        self.shadowRadius = 10
        self.shadowColor = UIColor.black.cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    public func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            masksToBounds = false
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
            self.contents = nil
            if let sublayer = sublayers?.first,
                sublayer.name == "Layer To Remove" {
                sublayer.removeFromSuperlayer()
            }
            
            let contentLayer = CALayer()
            contentLayer.name = "Layer To Remove"
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
    
    
    
}
