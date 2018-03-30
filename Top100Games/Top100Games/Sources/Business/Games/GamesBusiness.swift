//
//  GamesBusiness.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation
import Reachability

class GamesBusiness {
    
    private var topGames : GamesList?
    
    public func fetchTopGames(refresh : Bool = false, nextPage : Bool, _ completion : @escaping TopGamesCallback) {
        
        guard Reachability.isConnected else {
            // Implement core data logic to return saved games
            completion { self.topGames }
            return
        }
        
        if refresh {
            self.topGames = nil
        }
        
        if let currentUpcomingList = self.topGames {
            let currentPage: Int = currentUpcomingList.page
            let lastPage: Int = currentUpcomingList.totalPages
            if currentPage >= lastPage {
                completion { currentUpcomingList }
                return
            }
            
            if nextPage {
                self.topGames?.page = currentPage + 1
            }
        }
        
        let page = self.topGames?.page ?? 0
        
        GamesApiProvider.fetchTopGames(refresh: refresh, page: page) { [weak self] (gameList) in
            guard let _self = self else { return }
            
            guard let list = gameList() else {
                return
            }
            
            if _self.topGames == nil {
                _self.topGames = list
            } else {
                _self.append(gamesList: list, to: &_self.topGames)
            }
        
            completion { _self.topGames }
        }
        
    }
    
}

extension GamesBusiness {
    
    fileprivate func append(gamesList newList: GamesList, to oldList: inout GamesList?) {
        guard var list = oldList else { return }

        if let games = newList.games {
            list.games?.append(contentsOf: games)
        }
        
        oldList = list
    }
    
}
