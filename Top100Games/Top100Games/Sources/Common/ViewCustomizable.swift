//
//  ViewCustomizable.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation
import UIKit

protocol ViewCustomizable: class {
    associatedtype CustomView
    
    var customView: CustomView { get }
}

extension ViewCustomizable where Self : UIViewController {
    
    var customView: CustomView {
        guard let customView = self.view as? CustomView else { fatalError("Could not cast Custom View") }
        return customView
    }
}

