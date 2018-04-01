//
//  HomeCollectionViewController.swift
//  Top100Games
//
//  Created by Guilherme Antunes on 29/03/18.
//  Copyright © 2018 Guilherme Antunes. All rights reserved.
//

import UIKit
import Reachability
import Lottie

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
    
    private let animationView = LOTAnimationView(name: LocalizableStrings.emptyListAnimationName.localize())
    
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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHome()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !Reachability.isConnected {
            loadGames(showErrorAlertIfNeeded: false)
        }
    }
    
    // MARK: - Private Methods
    fileprivate func setupEmptyState() {
        title = LocalizableStrings.emptyStateScreenTitle.localize()
        animationView.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: 300, height: 200)
        animationView.center = CGPoint(x: view.center.x, y: view.center.y - 64)
        animationView.autoReverseAnimation = false
        animationView.loopAnimation = true
        collectionView?.addSubview(animationView)
        collectionView?.bringSubview(toFront: animationView)
        animationView.play()
    }
    
    fileprivate func removeEmptyStateViewIfNeeded() {
        title = LocalizableStrings.initialTitle.localize()
        animationView.removeFromSuperview()
    }
    
    private func stopLoading() {
        collectionView?.subviews.forEach({ (view) in
            if view is UIActivityIndicatorView {
                view.removeFromSuperview()
            }
        })
    }
    
    private func startLoading() {
        var shouldInsertActivityIndicator = true
        
        for view in view.subviews {
            if view is UIActivityIndicatorView {
                shouldInsertActivityIndicator = false
                break
            }
        }
        
        if shouldInsertActivityIndicator {
            let showActivity = UIActivityIndicatorView()
            showActivity.center = view.center
            showActivity.color = UIColor.white
            collectionView?.addSubview(showActivity)
            collectionView?.bringSubview(toFront: showActivity)
            showActivity.startAnimating()
        }
    }
    
    private func presentInternetErrorAlert() {
        let internetErrorAlert = createAlertWith(title: LocalizableStrings.offlineModeTitle.localize(), message: LocalizableStrings.offlineModeMessage.localize(), retryAction: true, { (action) in
            self.loadGames()
        })
        present(internetErrorAlert, animated: true, completion: nil)
    }
    
    private func setupHome() {
        collectionView?.alpha = 0
        collectionView?.refreshControl = refreshControl
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.allowsMultipleSelection = false
        loadGames()
    }

    fileprivate func loadGames(refresh : Bool = false, nextPage : Bool = false, showErrorAlertIfNeeded : Bool = true) {
        if !Reachability.isConnected {
            self.refreshControl.endRefreshing()
            if showErrorAlertIfNeeded { presentInternetErrorAlert() }
        }
        
        if !refresh && games?.isEmpty ?? true {
            startLoading()
        }
        
        self.removeEmptyStateViewIfNeeded()
        manager.fetchTopGames(refresh: refresh, nextPage: nextPage) { [weak self] (callback) in
            guard let _self = self else { return }
            if (_self.collectionView?.alpha == 0) { _self.collectionView?.alpha = 1 }
            _self.stopLoading()
            
            guard let list = callback() else { return }
            
            _self.returnedGames = list.games
            _self.refreshControl.endRefreshing()
            
            if _self.games?.count == 0 {
                _self.setupEmptyState()
            } else {
                _self.removeEmptyStateViewIfNeeded()
            }
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
        
        if indexPath.item >= (games?.count ?? 0) - 1 && Reachability.isConnected {
            loadGames(nextPage: true)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didEndDisplaying cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        guard let gameCell = cell as? GameCollectionViewCell else { return }
        guard Reachability.isConnected else { return }
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
        
        let width = (UIScreen.main.bounds.width - CGFloat(2*margin))/3

        let size = CGSize(width: width,
                          height: (width*1.41) + 30)
        
        return size
    }
}
