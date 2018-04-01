//
//  DetailsView.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import UIKit
import AlamofireImage
import Reachability

class DetailsView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameChannelsCount: UILabel!
    @IBOutlet weak var gameViewersCount: UILabel!
    @IBOutlet weak var saveGameButton: UIButton!
    
    // MARK: - Public Methods
    public func setupViewWith(model : Game) {
        if let image = model.image {
            gameImage.image = image
            self.applyGradient()
        } else {
            loadGamePoster(model.imageString)            
        }
        
        setupImageView()
        setupSaveGameButton(model.saved)
        gameName.text = model.gameName
        gameChannelsCount.text = "Contador de canais: " + String(describing: model.channels)
        gameViewersCount.text = "Quantidade de visualizações: " + String(describing: model.viewers)
    }
    
    // MARK: - Private Methods
    private func applyGradient() {
        self.gameImage.layer.insertSublayer(createBlackGradientLayer(forFrame: self.gameImage.frame), at: 0)
    }
    
    private func setupSaveGameButton(_ saved : Bool) {
        let image = saved ? UIImage(named: LocalizableStrings.saveButtonFilled.localize()) : UIImage(named: LocalizableStrings.saveButtonEmpty.localize())
        saveGameButton.setImage(image ?? UIImage(), for: .normal)
    }
    private func setupImageView() {
        gameImage.layer.cornerRadius = 10
        gameImage.clipsToBounds = true
    }
    
    private func loadGamePoster(_ string : String) {
        guard Reachability.isConnected else {
            return
        }
        
        guard let url = URL(string: string) else { return }

        startLoading(view: gameImage)
        
        let placeholderImage = #imageLiteral(resourceName: "bigEmptyImage")
        
        gameImage.af_setImage(withURL: url, placeholderImage: placeholderImage, progressQueue: .global(), imageTransition: .flipFromLeft(1.0), runImageTransitionIfCached: false) { (response) in
            self.applyGradient()
            stopLoading()
        }
    }

}
