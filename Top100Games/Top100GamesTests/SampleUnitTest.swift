//
//  SampleUnitTest.swift
//  Top100GamesTests
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import XCTest
@testable import Top100Games

class Top100GamesTests: XCTestCase {
    
    var gameList : GamesList?
    
    override func setUp() {
        super.setUp()
        let game1 = Game(name: "The Legend of Zelda: Breath of the Wild", channels: 1000, viewers: 2000, id: 1, image: nil)
        let game2 = Game(name: "Shadow of the Colossus", channels: 2000, viewers: 3000, id: 2, image: nil)
        let game3 = Game(name: "Kingdom Hearts", channels: 3000, viewers: 4000, id: 3, image: nil)
        gameList = GamesList(games: [game1, game2, game3])
    }
    
    override func tearDown() {
        gameList = nil
        super.tearDown()
    }
    
    func testGameListCreation() {
        guard let games = gameList?.games else {
            XCTAssertNil(gameList)
            XCTAssertNil(gameList?.games)
            return
        }
        
        XCTAssertNotNil(gameList)
        
        games.forEach { (game) in
            XCTAssertNil(game.image)
            XCTAssertNotNil(game.gameName)
            XCTAssertNotNil(game.gameId)
            XCTAssertNotNil(game.channels)
            XCTAssertNotNil(game.viewers)
        }
        
        // Zelda game
        XCTAssertTrue(games[0].gameName == "The Legend of Zelda: Breath of the Wild")
        XCTAssertTrue(games[0].gameId == 1)
        XCTAssertTrue(games[0].channels == 1000)
        XCTAssertTrue(games[0].viewers == 2000)
        
        XCTAssertFalse(games[0].gameName == "the legend of zelda: breath of the wild")
        XCTAssertFalse(games[0].gameId == 2)
        XCTAssertFalse(games[0].channels == 2000)
        XCTAssertFalse(games[0].viewers == 3000)
        
        // Shadow of the Colossus game
        XCTAssertTrue(games[1].gameName == "Shadow of the Colossus")
        XCTAssertTrue(games[1].gameId == 2)
        XCTAssertTrue(games[1].channels == 2000)
        XCTAssertTrue(games[1].viewers == 3000)
        
        XCTAssertFalse(games[1].gameName == "shadow of the colossus")
        XCTAssertFalse(games[1].gameId == 3)
        XCTAssertFalse(games[1].channels == 3000)
        XCTAssertFalse(games[1].viewers == 4000)
        
        // Kingdom Hearts game
        XCTAssertTrue(games[2].gameName == "Kingdom Hearts")
        XCTAssertTrue(games[2].gameId == 3)
        XCTAssertTrue(games[2].channels == 3000)
        XCTAssertTrue(games[2].viewers == 4000)
        
        XCTAssertFalse(games[2].gameName == "kingdom hearts")
        XCTAssertFalse(games[2].gameId == 1)
        XCTAssertFalse(games[2].channels == 1000)
        XCTAssertFalse(games[2].viewers == 2000)
        
    }
    
}
