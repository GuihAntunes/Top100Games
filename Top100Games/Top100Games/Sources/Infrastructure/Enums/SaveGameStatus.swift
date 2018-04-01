//
//  SaveGameStatus.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 30/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation

enum SaveGameStatus {
    case saved
    case deleted
    case retrieved
    case failed(String)
}
