//
//  GameCollectionViewCell.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import UIKit
import AlamofireImage
import Reachability

class GameCollectionViewCell: UICollectionViewCell, Identifiable {
    
    // MARK: - Outlets
    @IBOutlet weak var gamePoster: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    
    // MARK: - Public Methods
    public func setupCellWithModel(_ model : Game) {
        if !Reachability.isConnected {
            if let poster = model.image {
                gamePoster.image = poster
            }
        } else {
            loadGamePoster(imageString: model.thumbnailString)
        }
        
        setupGamePosterView()
        gameNameLabel.text = model.gameName
    }
    
    // MARK: - Private Methods
    private func setupGamePosterView() {
        layer.cornerRadius = 10
        clipsToBounds = true
        gamePoster.layer.cornerRadius = 10
        gamePoster.clipsToBounds = true
        gamePoster.contentMode = .scaleAspectFill
    }
    
    private func loadGamePoster(imageString string : String) {
        guard let url = URL(string: string) else { return }
        
        let placeholderImage = #imageLiteral(resourceName: "emptyImage")
        
        gamePoster.af_setImage(withURL: url,  placeholderImage: placeholderImage, progressQueue: .global(), imageTransition: .flipFromTop(0.5), runImageTransitionIfCached: false)
        
    }
    
    // MARK: - Override
    override func prepareForReuse() {
        gameNameLabel.text = ""
        gamePoster.af_cancelImageRequest()
    }
    
    
}
