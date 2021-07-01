//
//  WatchlistView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-17.
//

import UIKit

protocol WatchlistViewDelegate: class {
    func presentMovieDetails(movie: Movie)
    func goToCombineWatchlist()
}

class WatchlistView: UIView {
    
    //MARK: - Properties
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    weak var delegate: WatchlistViewDelegate?
        
    private lazy var movieTable = MovieTable(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    private lazy var movieCollection = MovieCollection(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    
    private let collectionIcon: UIImage? = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: "square.grid.2x2", withConfiguration: imageConfig)?.withTintColor(K.MAIN_COLOR, renderingMode: .alwaysOriginal)
        return image
    }()
    
    private let tableIcon: UIImage? = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: "list.dash", withConfiguration: imageConfig)?.withTintColor(K.MAIN_COLOR, renderingMode: .alwaysOriginal)
        return image
    }()
    
    private lazy var toggleViewModeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(toggleViewMode), for: .touchUpInside)
        button.setImage(collectionIcon, for: .normal)
        return button
    }()
    
    private let matchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.setTitle("Combine watchlists", for: .normal)
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(goToMatchView), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        movieTable.delegate = self
        movieCollection.delegate = self
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    func fetchAndConfigureMovies() {
        guard let watchlist = sceneDelegate.user != nil ? sceneDelegate.user?.watchlist : sceneDelegate.localUser?.watchlist else { return }
        
        if watchlist.count == sceneDelegate.userWatchlist.count {
            displayMovies()
            return
        }
        sceneDelegate.userWatchlist = []
        watchlist.forEach { movieId in
            TmdbService.fetchMovieWithDetails(withId: movieId) { movie in
                self.sceneDelegate.userWatchlist.append(movie)
                if self.sceneDelegate.userWatchlist.count == watchlist.count {
                    self.displayMovies()
                }
            }
        }
    }
    
    @objc func goToMatchView() {
        delegate?.goToCombineWatchlist()
    }
    
    @objc func showTableView() {
        movieCollection.alpha = 0
        movieTable.alpha = 1

        toggleViewModeButton.setImage(collectionIcon, for: .normal)
        UserDefaults.standard.setValue(true, forKey: K.WATCHLIST_IS_TABLE)
    }
    
    @objc func showCollectionView() {
        movieTable.alpha = 0
        movieCollection.alpha = 1
                
        toggleViewModeButton.setImage(tableIcon, for: .normal)
        UserDefaults.standard.setValue(false, forKey: K.WATCHLIST_IS_TABLE)
    }
    
    @objc func toggleViewMode() {
        let currentIcon = toggleViewModeButton.imageView?.image
        toggleViewModeButton.setImage(nil, for: .normal)
        currentIcon == tableIcon ? showTableView() : showCollectionView()
        
    }
    
    func presentMovieDetails(movie: Movie) {
        delegate?.presentMovieDetails(movie: movie)
    }
    
    //MARK: - Helpers
    
    func displayMovies() {
        movieTable.movies = sceneDelegate.userWatchlist
        movieCollection.movies = sceneDelegate.userWatchlist
                
        if UserDefaults.standard.bool(forKey: K.WATCHLIST_IS_TABLE) {
            showTableView()
        } else {
            showCollectionView()
        }
    }
    
    func configureUI() {
        
        addSubview(matchButton)
        matchButton.anchor(top: topAnchor, left: leftAnchor, paddingLeft: 20)
        
        addSubview(toggleViewModeButton)
        toggleViewModeButton.anchor(top: topAnchor, left: matchButton.rightAnchor, right: rightAnchor, paddingLeft: 15, paddingRight: 15, width: 60)

        addSubview(movieTable)
        movieTable.anchor(top: matchButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 15, paddingRight: 10)
        
        addSubview(movieCollection)
        movieCollection.anchor(top: matchButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
    }
    
}

//MARK: - MovieTableDelegate

extension WatchlistView: MovieTableDelegate {
    func tablePresentMovieDetails(movie: Movie) {
        presentMovieDetails(movie: movie)
    }
}

//MARK: - MovieCollectionDelegate

extension WatchlistView: MovieCollectionDelegate {
    func collectionPresentMovieDetails(movie: Movie) {
        presentMovieDetails(movie: movie)
    }
}
