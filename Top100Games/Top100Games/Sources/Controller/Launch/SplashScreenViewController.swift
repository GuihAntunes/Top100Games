//
//  SplashScreenViewController.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import UIKit
import Lottie

class SplashScreenViewController: UIViewController {

    // MARK: - Properties
    private lazy var initialAnimation = LOTAnimationView(name: LocalizableStrings.initialAnimationName.localize())
    
    // MARK: - View Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playLottieAnimation()
    }
    
    // MARK: - General Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let homeController = segue.destination as? UINavigationController else {
            return
        }
        homeController.transitioningDelegate = self
        homeController.modalPresentationStyle = .custom
    }
    
    private func playLottieAnimation() {
        initialAnimation.autoReverseAnimation = false
        initialAnimation.frame = CGRect(x: view.frame.width / 4 - 125, y: view.frame.width / 4 - 125, width: 350, height: 350)
        initialAnimation.center = view.center
        view.addSubview(initialAnimation)
        initialAnimation.play { (success) in
            if success {
                self.initialAnimation.alpha = 0
                self.performSegue(withIdentifier: HomeCollectionViewController.segueIdentifier, sender: nil)
            }
        }
    }
    
    // MARK: - Actions

}
