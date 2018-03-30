//
//  Game.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation
import Freddy

struct Game : JSONDecodable {
    
    var gameName : String
    var channels : Int
    var viewers : Int
    var thumbnailString : String
    var imageString : String
    
    public init(json: JSON) throws {
        gameName = try json.getString(at: "game", "name")
        channels = try json.getInt(at: "channels")
        viewers = try json.getInt(at: "viewers")
        thumbnailString = try json.getString(at: "game", "box", "medium")
        imageString = try json.getString(at: "game", "box", "large")
    }
}
