//
//  HomeManager.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation

class HomeManager : BaseManager {
    
    // Games Business
    private lazy var business: GamesBusiness = {
        return GamesBusiness()
    }()
    
    public func fetchTopGames(refresh : Bool = false, nextPage : Bool = false, _ completion : @escaping TopGamesCallback) {
        addOperation {
            self.business.fetchTopGames(refresh: refresh, nextPage: nextPage, { (callback) in
                OperationQueue.main.addOperation {
                    completion(callback)
                }
            })
        }
    }
    
}

