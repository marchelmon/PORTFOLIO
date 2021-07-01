//
//  MatchingResultsView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-21.
//

import UIKit

protocol MatchingResultsViewDelegate: class {
    func tablePresentMovieDetails(movie: Movie)
}

class MatchingResultsView: UIView {
    
    //MARK: - Properties

    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    weak var delegate: MatchingResultsViewDelegate?
    
    var friends: [User]! {
        didSet{ calculateMovieLists() }
    }
    
    private let watchlistResultsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("* VS *", for: .normal)
        button.setTitleColor(K.MAIN_COLOR, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(showWatchlistResults), for: .touchUpInside)
        return button
    }()

    private let excludeResultsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("* VS X", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(showExcludeResults), for: .touchUpInside)
        return button
    }()
    
    private let watchlistResultsTable = MovieTable()
    private let excludeResultsTable = MovieTable()

    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        watchlistResultsTable.delegate = self
        excludeResultsTable.delegate = self
        
        configureUI()
        showWatchlistResults()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Actions
    
    func calculateMovieLists() {
        
        guard let user = sceneDelegate.user else { return }
        
        var matchedWatchlistMovies = [Movie]()
        var notExcludedMovies = [Movie]()
        
        var matchedInWatchlist = [Int]()
        var notExcludedList = [Int]()
        
        var friendsWatchlist = [Int]()
        var friendsExcluded = [Int]()
        
        friends.forEach({ friend in
            friendsWatchlist += friend.watchlist
            friendsExcluded += friend.excluded
        })

        user.watchlist.forEach { movieId in
            if friendsWatchlist.contains(movieId) { matchedInWatchlist.append(movieId) }
            if !friendsExcluded.contains(movieId) { notExcludedList.append(movieId) }
        }
        
        matchedInWatchlist.forEach { movieId in
            TmdbService.fetchMovieWithDetails(withId: movieId) { movie in
                matchedWatchlistMovies.append(movie)
                if matchedWatchlistMovies.count == matchedInWatchlist.count {
                    self.watchlistResultsTable.movies = matchedWatchlistMovies
                }
            }
        }
        
        notExcludedList.forEach { movieId in
            TmdbService.fetchMovieWithDetails(withId: movieId) { movie in
                notExcludedMovies.append(movie)
                if notExcludedMovies.count == notExcludedList.count {
                    self.excludeResultsTable.movies = notExcludedMovies
                }
            }
        }
        
    }

    @objc func showWatchlistResults() {
        excludeResultsTable.isHidden = true
        watchlistResultsTable.isHidden = false

        watchlistResultsButton.setTitleColor(K.MAIN_COLOR, for: .normal)
        excludeResultsButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
    }

    @objc func showExcludeResults() {
        watchlistResultsTable.isHidden = true
        excludeResultsTable.isHidden = false
        
        excludeResultsButton.setTitleColor(K.MAIN_COLOR, for: .normal)
        watchlistResultsButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        let topButtonStack = UIStackView(arrangedSubviews: [UIView(), watchlistResultsButton, excludeResultsButton, UIView()])
        topButtonStack.backgroundColor = .white
        topButtonStack.distribution = .equalSpacing

        addSubview(topButtonStack)
        topButtonStack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 70)

        addSubview(watchlistResultsTable)
        watchlistResultsTable.anchor(top: topButtonStack.bottomAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 15)

        addSubview(excludeResultsTable)
        excludeResultsTable.anchor(top: topButtonStack.bottomAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 15)
        
    }
    
}

//MARK: - MovieTableDelegate

extension MatchingResultsView: MovieTableDelegate {
    func tablePresentMovieDetails(movie: Movie) {
        delegate?.tablePresentMovieDetails(movie: movie)
    }
}
