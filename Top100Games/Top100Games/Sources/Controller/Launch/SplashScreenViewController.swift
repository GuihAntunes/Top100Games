//
//  SplashScreenViewController.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performSegue(withIdentifier: HomeCollectionViewController.segueIdentifier, sender: nil)
    }
    
    // MARK: - General Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let homeController = segue.destination as? UINavigationController else {
            return
        }
        homeController.transitioningDelegate = self
        homeController.modalPresentationStyle = .custom
    }
    
    // MARK: - Actions

}
