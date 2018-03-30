//
//  HomeCollectionViewController.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController, Identifiable {
    
    // MARK: - Properties
    fileprivate var games : [Game]? {
        get {
            return returnedGames
        }
        
        set {
            returnedGames = newValue
        }
    }
    
    fileprivate var returnedGames : [Game]? {
        didSet {
            if returnedGames != nil {
                collectionView?.reloadData()
            }
        }
    }
    
    fileprivate var selectedGame : Game?
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(HomeCollectionViewController.refresh),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    private lazy var manager = {
        return HomeManager()
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHome()
    }
    
    // MARK: - General Methods
    private func setupHome() {
        collectionView?.refreshControl = refreshControl
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.allowsMultipleSelection = false
        loadGames()
    }
    
    fileprivate func handlePagination(lastItem : Int) {
        if lastItem >= (games?.count ?? 0) - 1 {
            loadGames(nextPage: true)
        }
    }

    fileprivate func loadGames(refresh : Bool = false, nextPage : Bool = false) {
        startLoading(view: view)
        manager.fetchTopGames(refresh: refresh, nextPage: nextPage) { [weak self] (callback) in
            guard let _self = self else { return }
            
            guard let list = callback() else { return }
            
            _self.returnedGames = list.games
            _self.refreshControl.endRefreshing()
            stopLoading()
        }
    }
    
    @objc private func refresh() {
        games?.removeAll()
        collectionView?.reloadData()
        loadGames(refresh: true)
    }
    
    // MARK: - Actions

}

// MARK: - UICollectionViewDataSource n' UICollectionViewDelegate methods
extension HomeCollectionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsController = segue.destination as? DetailsViewController,
            let selectedIndexPath = collectionView?.indexPathsForSelectedItems?.first else {
                return
        }
        
        detailsController.transitioningDelegate = self
        detailsController.modalPresentationStyle = .custom
        detailsController.setSelectedGame(games?[selectedIndexPath.item])
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return games?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: GameCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        guard let game = games?[indexPath.item] else { return cell }
        
        cell.setupCellWithModel(game)
        
        if PaginationFeatureToggle.isPaginationEnabled {
            handlePagination(lastItem: indexPath.item)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didEndDisplaying cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        guard let gameCell = cell as? GameCollectionViewCell else { return }
        gameCell.gamePoster.af_cancelImageRequest()
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        guard let game = games?[indexPath.row] else { return }
        self.selectedGame = game
        performSegue(withIdentifier: DetailsViewController.segueIdentifier, sender: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin = 10
        
        var width = (UIScreen.main.bounds.width - CGFloat(2*margin))/3
        
        if UIDevice.current.orientation.isLandscape {
            width = (UIScreen.main.bounds.width - CGFloat(4*margin))/5
        }
        
        let size = CGSize(width: width,
                          height: (width*1.41) + 30)
        
        return size
    }
}
