//
//  EmptyStateView.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 06/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import UIKit

class EmptyStateView: UITextView {

    public func setup() {
        text = "Ooops! There's no games around here!"
        textAlignment = .center
        isUserInteractionEnabled = false
        textColor = .white
        font = UIFont(name: "Avenir Next", size: 20)
        backgroundColor = UIColor.clear
    }

}
