//
//  GamesApiProvider.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

typealias TopGamesCallback = (@escaping () -> GamesList?) -> Void

struct GamesApiProvider {

    static let clientId = "gpu0x967cngm0pm2yx96qya4bamy9c"
    
    static let acceptParameter = "application/vnd.twitchtv.v5+json"
    
    static let header : HTTPHeaders = [
        "Client-ID" : clientId,
        "Accept" : acceptParameter
    ]
    
    static var baseUrl: String {
        return "https://api.twitch.tv/kraken/games/top"
    }
    
    static var pageQuery: String {
        return "&offset="
    }
    
    static var limitQuery: String {
        var limit = 100
        if PaginationFeatureToggle.isInfinitPaginationEnabled {
            limit = 50
        } else if PaginationFeatureToggle.isPaginationEnabled {
            limit = 20
        }
        return "?limit=\(limit)"
    }
    
    static func fetchTopGames(refresh : Bool = false, page : Int = 0, completion : @escaping TopGamesCallback) {
        guard let url = URL(string: baseUrl + limitQuery + pageQuery + String(describing: page)) else {
            print("Failed to get url from string")
            return
        }
        
        Alamofire.request(url, headers: header).validate().responseJSON { (response) in
            guard let data = response.data else {
                return
            }
            
            let json = try? JSON(data: data)
            
            do {
                let gameList = try json?.decode(type: GamesList.self)
                completion { gameList }
            } catch let error {
                print(error)
                return
            }
        }
        
    }
    
}
