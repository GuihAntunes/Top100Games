//
//  LocalizableStrings.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 30/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation

enum LocalizableStrings: String {
    
    // Strings
    case okActionTitle
    case tryAgainTitle
    case savedOnCoreDataTitle
    case saveOnCoreDataMessage
    case deletedFromCoreDataTitle
    case deletedFromCoreDataMessage
    
    // Images names
    case saveButtonFilled
    case saveButtonEmpty
    
    // Error Handling
    case failedToSaveOnCoreDataTitle
    case failedToSaveOnCoreDataMessage
    case failedDeleteFromCoreDataTitle
    case failedDeleteFromCoreDataMessage
    case offlineModeTitle
    case offlineModeMessage
    case invalidURL
    case genericError
    
    func localize() -> String {
        return self.rawValue.localize()
    }
}
