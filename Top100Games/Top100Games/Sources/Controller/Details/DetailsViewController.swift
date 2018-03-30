//
//  DetailsViewController.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, ViewCustomizable, Identifiable {
   
    typealias CustomView = DetailsView

    // MARK: - Properties
    private var selectedGame : Game? {
        didSet {
            if selectedGame != nil {
                setupDetails()
            }
        }
    }
    
    // MARK: - General Methods
    public func setSelectedGame(_ game : Game?) {
        selectedGame = game
    }
    
    private func setupDetails() {
        guard let game = selectedGame else { return }
        title = game.gameName
        customView.setupViewWith(model: game)
    }
    
    // MARK: - Actions

}
