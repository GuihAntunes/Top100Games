//
//  GamesList.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation
import Freddy

struct GamesList : JSONDecodable {
    
    var games : [Game]?
    var page : Int = 0
    var totalResults : Int?
    var totalPages : Int = Int.max
    
    public init(json: JSON) throws {
        totalResults = try json.getInt(at: "_total")
        games = try json.getArray(at: "top").map(Game.init)
        let totalPages : Double = Double(integerLiteral: Int64(totalResults ?? 100)) / 10.0
        self.totalPages = Int(totalPages.rounded(.up))
    }
    
}
