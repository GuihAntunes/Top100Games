//
//  DetailsManager.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 30/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation
import UIKit

class DetailsManager: BaseManager {
    
    // Games Business
    private lazy var business: GamesBusiness = {
        return GamesBusiness()
    }()
    
    public func saveGame(_ game : Game, image : UIImage) -> SaveGameStatus {
        return self.business.saveGame(game, image: image)
    }
    
    public func deleteGame(_ game : Game) -> SaveGameStatus {
        return self.business.deleteGame(game)
    }
    
}
