//
//  GameCollectionViewCell.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import UIKit
import AlamofireImage

class GameCollectionViewCell: UICollectionViewCell, Identifiable {
    
    // MARK: - Outlets
    @IBOutlet weak var gamePoster: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    
    // MARK: - Public Methods
    public func setupCellWithModel(_ model : Game) {
        setupGamePosterView()
        gameNameLabel.text = model.gameName
        loadGamePoster(imageString: model.thumbnailString)
    }
    
    // MARK: - Private Methods
    private func setupGamePosterView() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        gamePoster.layer.cornerRadius = 10
        gamePoster.clipsToBounds = true
        gamePoster.contentMode = .scaleAspectFill
    }
    
    private func loadGamePoster(imageString string : String) {
        
        guard let url = URL(string: string) else { return }
        
        gamePoster.af_setImage(withURL: url, progressQueue: .global(), imageTransition: .flipFromTop(0.5), runImageTransitionIfCached: false)
        
    }
    
    // MARK: - Override
    override func prepareForReuse() {
        gameNameLabel.text = ""
        gamePoster.image = UIImage()
        gamePoster.af_cancelImageRequest()
    }
    
    
}
