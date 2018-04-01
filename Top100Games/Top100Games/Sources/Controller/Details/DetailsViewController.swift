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
    
    private lazy var manager = {
        return DetailsManager()
    }()
    
    // MARK: - Public Methods
    public func setSelectedGame(_ game : Game?) {
        selectedGame = game
    }
    
    // MARK: - Private Methods
    private func setupDetails() {
        guard let game = selectedGame else { return }
        title = game.gameName
        customView.setupViewWith(model: game)
    }
    
    private func createAlertForCoreDataResponse(response : SaveGameStatus) {
        var alert : UIAlertController?
        switch response {
        case .saved:
            alert = createAlertWith(title: LocalizableStrings.savedOnCoreDataTitle.localize(), message: LocalizableStrings.saveOnCoreDataMessage.localize(), retryAction: false, { (action) in })
            selectedGame?.saved = true
        case .deleted:
            alert = createAlertWith(title: LocalizableStrings.deletedFromCoreDataTitle.localize(), message: LocalizableStrings.deletedFromCoreDataMessage.localize(), retryAction: false, { (action) in })
            selectedGame?.saved = false
        default:
            alert = createAlertWith(title: LocalizableStrings.failedToSaveOnCoreDataTitle.localize(), message: LocalizableStrings.failedToSaveOnCoreDataMessage.localize(), retryAction: true, { (action) in
                self.saveGame(self.customView.saveGameButton)
            })
            selectedGame?.saved = false
        }
        
        if let alertController = alert {
            present(alertController, animated: true, completion: {
                self.updateSaveButton(wasSaved: self.selectedGame?.saved ?? false)
            })
        }
    }
    
    private func updateSaveButton(wasSaved saved : Bool) {
        var image = UIImage()
        if saved {
            image = UIImage(named: LocalizableStrings.saveButtonFilled.localize()) ?? UIImage()
        } else {
            image = UIImage(named: LocalizableStrings.saveButtonEmpty.localize()) ?? UIImage()
        }
        
        customView.saveGameButton.setImage(image, for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func saveGame(_ sender: UIButton) {
        guard let game = selectedGame else { return }
        if game.saved {
            createAlertForCoreDataResponse(response: manager.deleteGame(game))
        } else {
            createAlertForCoreDataResponse(response: manager.saveGame(game, image: customView.gameImage.image ?? UIImage()))
        }
    }
    
}
