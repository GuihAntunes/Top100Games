//
//  GamesBusiness.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation
import Reachability
import CoreData

typealias CoreDataCallback = (GamesList?, SaveGameStatus)

class GamesBusiness {
    
    // MARK: - Properties
    private var topGames : GamesList?
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // MARK: - Public Methods
    public func fetchTopGames(refresh : Bool = false, nextPage : Bool, _ completion : @escaping TopGamesCallback) {
        
        guard Reachability.isConnected else {
            DispatchQueue.main.sync {
                self.handleCoreDataRequest()
                completion { self.topGames }
            }
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
            
            guard var list = gameList() else {
                return
            }
            
            if let gamesArray = list.games {
                list.games = gamesArray.map({ game in
                    let newGame = game
                    newGame.saved = _self.checkCachedGamesForGame(game)
                    return newGame
                })
            }
            
            if _self.topGames == nil {
                _self.topGames = list
            } else {
                _self.append(gamesList: list, to: &_self.topGames)
            }

            completion { _self.topGames }
        }
        
    }
    
    public func saveGame(_ game : Game, image : UIImage) -> SaveGameStatus {
        guard let delegate = appDelegate else {
            return .failed(LocalizableStrings.failedToCreateAppDelegate.localize())
        }
        
        let context = delegate.persistentContainer.viewContext
        
        if self.checkCachedGamesForGame(game) {
            return .saved
        }
        
        let newGame = NSEntityDescription.insertNewObject(forEntityName: LocalizableStrings.gameCoreDataEntityName.localize(), into: context)
        
        newGame.setValue(game.gameName, forKey: "name")
        newGame.setValue(String(describing: game.channels), forKey: "channels")
        newGame.setValue(String(describing: game.viewers), forKey: "viewers")
        newGame.setValue(Int64(game.gameId), forKey: "id")
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        newGame.setValue(imageData, forKey: "image")
        
        do {
            try context.save()
            return .saved
        } catch let error {
            print(error)
            return .failed(error.localizedDescription)
        }
    }
    
    public func deleteGame(_ game : Game) -> SaveGameStatus {
        guard let delegate = appDelegate else {
            return .failed(LocalizableStrings.failedToCreateAppDelegate.localize())
        }
        
        let context = delegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: LocalizableStrings.gameCoreDataEntityName.localize())
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id==\(Int64(game.gameId))")
        
        do {
            guard let results = try context.fetch(request) as? [NSManagedObject] else {
                return .failed(LocalizableStrings.failedToRetrieveFromCoreData.localize())
            }
            
            results.forEach { (coreDataItem) in
                context.delete(coreDataItem)
            }
        } catch {
            return .failed(LocalizableStrings.failedDeleteFromCoreDataTitle.localize())
        }
        
        return .deleted
    }
    
    // MARK: - Private Methods
    fileprivate func checkCachedGamesForGame(_ game : Game) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: LocalizableStrings.gameCoreDataEntityName.localize())
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id==\(Int64(game.gameId))")
        
        var results : [NSManagedObject]?
        
        do {
            results = try context.fetch(request) as? [NSManagedObject]
        } catch {
            return false
        }
        
        if let gamesRetrivedCount = results?.count, gamesRetrivedCount > 0 {
            return true
        } else {
            return false
        }
    }
    
    private func getGamesFromCoreData() -> CoreDataCallback {
        guard let delegate = appDelegate else {
            return CoreDataCallback(nil, .failed(LocalizableStrings.failedToCreateAppDelegate.localize()))
        }
        
        let context = delegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: LocalizableStrings.gameCoreDataEntityName.localize())
        
        request.returnsObjectsAsFaults = false
        
        var retrievedGames : [Game] = []
        
        do {
            guard let results = try context.fetch(request) as? [NSManagedObject] else {
                return CoreDataCallback(nil, .failed(LocalizableStrings.failedToRetrieveFromCoreData.localize()))
            }
            
            if results.count > 0 {
                results.forEach { (coreDataItem) in
                    if let gameName = coreDataItem.value(forKey: LocalizableStrings.coreDataNameAttribute.localize()) as? String, let gameChannels = coreDataItem.value(forKey: LocalizableStrings.coreDataChannelsAttribute.localize()) as? String, let gameViewers = coreDataItem.value(forKey: LocalizableStrings.coreDataViewersAttribute.localize()) as? String, let gameId = coreDataItem.value(forKey: LocalizableStrings.coreDataIdAttribute.localize()) as? Int64, let imageData = coreDataItem.value(forKey: LocalizableStrings.coreDataImageAttribute.localize()) as? Data {
                        let game = Game(name: gameName, channels: Int(gameChannels) ?? 0, viewers: Int(gameViewers) ?? 0, id : Int(gameId), image : UIImage(data: imageData))
                        game.saved = true
                        retrievedGames.append(game)
                    }
                }
            }
            
        } catch let error {
            return CoreDataCallback(nil, .failed(error.localizedDescription))
        }
        
        return CoreDataCallback(GamesList(games: retrievedGames), .retrieved)
    }
    
    private func handleCoreDataRequest() {
        let coreDataResults = getGamesFromCoreData()
        
        switch coreDataResults.1 {
        case .retrieved:
            self.topGames = coreDataResults.0
        default:
            self.topGames = nil
        }
    }
    
}

extension GamesBusiness {
    
    fileprivate func append(gamesList newList: GamesList, to oldList: inout GamesList?) {
        guard var list = oldList else { return }
        
        if let games = newList.games {
            list.games?.append(contentsOf: games)
        }
        
        var filteredArray = Set<Game>()
        let uniqueGames = list.games?.flatMap { (game) -> Game? in
            guard !filteredArray.contains(game) else { return nil }
            filteredArray.insert(game)
            return game
        }
        
        list.games = uniqueGames
        
        oldList = list
    }
    
}
