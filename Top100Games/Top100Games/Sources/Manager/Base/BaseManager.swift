//
//  BaseManager.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import Foundation

class BaseManager: OperationQueue {
    
    /**
     Initialize an BaseManager subclass.
     
     - parameter maxConcurrentOperationCount: maximun number of concurrent operations.
     
     - returns: an instance of BaseManager subclass.
     */
    convenience init(maxConcurrentOperationCount: Int) {
        self.init()
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
    }
    
    // MARK: Deinitalizers
    
    deinit {
        cancelAllOperations()
    }
}
