//
//  Game.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation
import UIKit
import Freddy

class Game : JSONDecodable, Hashable, Equatable {
    var hashValue: Int { get { return gameId } }
    var gameName : String
    var channels : Int
    var viewers : Int
    var thumbnailString : String
    var imageString : String
    var image : UIImage?
    var saved = false
    var gameId : Int

    public init(name : String, channels : Int, viewers : Int, id : Int, image : UIImage?) {
        self.gameName = name
        self.channels = channels
        self.viewers = viewers
        self.thumbnailString = ""
        self.imageString = ""
        self.gameId = id
        self.image = image
    }
    
    public required init(json: JSON) throws {
        gameName = try json.getString(at: "game", "name")
        channels = try json.getInt(at: "channels")
        viewers = try json.getInt(at: "viewers")
        thumbnailString = try json.getString(at: "game", "box", "medium")
        imageString = try json.getString(at: "game", "box", "large")
        gameId = try json.getInt(at: "game", "_id")
    }
    
    static func ==(left:Game, right:Game) -> Bool {
        return left.gameId == right.gameId
    }
}
