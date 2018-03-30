//
//  DetailsView.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailsView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameChannelsCount: UILabel!
    @IBOutlet weak var gameViewersCount: UILabel!
    
    // MARK: - Public Methods
    public func setupViewWith(model : Game) {
        setupImageView()
        gameName.text = model.gameName
        gameChannelsCount.text = "Contador de canais: " + String(describing: model.channels)
        gameViewersCount.text = "Quantidade de visualizações: " + String(describing: model.viewers)
        loadGamePoster(model.thumbnailString)
    }
    
    // MARK: - Private Methods
    private func setupImageView() {
        gameImage.layer.cornerRadius = 10
        gameImage.clipsToBounds = true
    }
    
    private func loadGamePoster(_ string : String) {
        guard let url = URL(string: string) else { return }
        
        gameImage.af_setImage(withURL: url, progressQueue: .global(), imageTransition: .flipFromBottom(0.5), runImageTransitionIfCached: false)
    }

}
