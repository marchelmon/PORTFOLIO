//
//  SwipeView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-15.
//

import UIKit
import Firebase

protocol SwipeViewDelegate: class {
    func showMovieDetails(for movie: Movie)
    func showFilter()
    func swipeViewAlert(text: String, alertAction: UIAlertAction?)
}

class SwipeView: UIView {
    
    //MARK: - Properties
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    weak var delegate: SwipeViewDelegate?
    
    private var swipeAnimationReady = true
    
    private var movies = [Movie]() {
        didSet { configureCards() }
    }
        
    var moviesToDisplay = [Movie]()
    
    var topCardView: CardView?
    private var cardViews = [CardView]()
    
    private let bottomStack = BottomControlsStackView()

    private let deckView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let refillMoviesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Fetch new movies", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
        button.layer.borderWidth = 5
        button.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(refillMovies), for: .touchUpInside)
        return button
    }()
    
    lazy var watchlistStat = createStatIcon(statIcon: K.WATCHLIST_ICON)
    lazy var excludeStat = createStatIcon(statIcon: K.EXCLUDE_ICON)
    lazy var skipStat = createStatIcon(statIcon: K.SKIP_ICON)
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bottomStack.delegate = self
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func performSwipeAnimation(topCard: CardView, shouldExclude: Bool) {
        
        swipeAnimationReady = false
        
        let translation: CGFloat = shouldExclude ? -700 : 700
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .transitionCurlDown) {
            topCard.frame = CGRect(x: translation, y: 0, width: (topCard.frame.width), height: (topCard.frame.height))
        } completion: { _ in
            
            self.swipeAnimationReady = true
            self.updateCardView()
        }
    }
    
    func fetchFilterAndMovies() {
        setStatLabels()
        FilterService.fetchFilter { filter in
            //self.fetchMovies(filter: filter) TODO
        }
    }
    
    @objc func refillMovies() {
        resetMovieData()
        print("FETCH MOVIES")
        fetchMovies(filter: FilterService.filter)
    }
    
    func fetchMovies(filter: Filter) {
        if filter.page == filter.totalPages {
            delegate?.swipeViewAlert(text: "There are no more movies with this active filter, change genres or years to bring new content", alertAction: nil)
            return
        }
        
        TmdbService.fetchMovies(completion: { (movies, error) in
            
            if error != nil {
                self.delegate?.swipeViewAlert(text: "The movie database (TMDB) did not respond, try again later or restart the app", alertAction: nil)
                return
            }
            guard let movies = movies else {
                self.delegate?.swipeViewAlert(text: "A problem occured fetching movies, try changing your filter or restarting the app", alertAction: nil)
                return
            }
            self.moviesToDisplay.append(contentsOf: movies)
            
            if self.moviesToDisplay.count > 15 {
                self.movies = self.moviesToDisplay
            } else {
                self.fetchMovies(filter: filter)
            }
        })
    }
    
    //MARK: - Helpers
    
    func configureCards() {
        refillMoviesButton.isHidden = true
        for view in deckView.subviews {
            view.removeFromSuperview()
        }
        for movie in movies {
            let cardView = CardView(movie: movie)
            cardView.delegate = self
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        cardViews = deckView.subviews.map({ ($0 as? CardView)! })
        topCardView = cardViews.last
    }
    
    func configureUI() {
        backgroundColor = .white
        
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let midStack = UIStackView(arrangedSubviews: [spacer, deckView, spacer])
        let statsStack = UIStackView(arrangedSubviews: [excludeStat, watchlistStat, skipStat])
        
        statsStack.spacing = 10
        
        let alignmentStack = UIStackView()
        alignmentStack.axis = .vertical
        alignmentStack.alignment = .leading
        alignmentStack.addArrangedSubview(statsStack)
        alignmentStack.heightAnchor.constraint(equalToConstant: 20).isActive = true

        
        let stack = UIStackView(arrangedSubviews: [alignmentStack, midStack, bottomStack])
        stack.spacing = 12
        stack.axis = .vertical

        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
                
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        stack.bringSubviewToFront(deckView)
        addSubview(refillMoviesButton)
        refillMoviesButton.centerInSuperview()
        refillMoviesButton.setDimensions(height: 60, width: 240)
        //refillMoviesButton.isHidden = true
        
    }
    
    func resetMovieData() {
        topCardView = nil
        cardViews = []
        moviesToDisplay = []
        movies = []
    }
    
    func createStatIcon(statIcon: UIImage?) -> UIButton {
        let icon = statIcon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12))
        let statView = UIButton(type: .system)
        statView.isEnabled = false
        statView.setImage(icon, for: .normal)
        statView.setTitleColor(.black, for: .normal)
        statView.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return statView
    }
    
    func setStatLabels() {
        if let user = sceneDelegate.user {
            
            self.excludeStat.setTitle(" \(user.excludedCount)", for: .normal)
            self.watchlistStat.setTitle(" \(user.watchListCount)", for: .normal)
            self.skipStat.setTitle(" \(user.skippedCount)", for: .normal)
            
        } else if let user = sceneDelegate.localUser {
            
            self.excludeStat.setTitle(" \(user.excluded.count)", for: .normal)
            self.watchlistStat.setTitle(" \(user.watchlist.count)", for: .normal)
            self.skipStat.setTitle(" \(user.skipped.count)", for: .normal)
            
        }

    }
    
    func updateCardView() {
        self.topCardView?.removeFromSuperview()
        guard !self.cardViews.isEmpty else { return }
        self.cardViews.remove(at: self.cardViews.count - 1)
        self.topCardView = self.cardViews.last
        if cardViews.count == 0 { refillMoviesButton.isHidden = false }
    }
    
}

//MARK: - CardViewDelegate

extension SwipeView: CardViewDelegate {
    func cardView(_ view: CardView, wantsToShowDetailsFor movie: Movie) {
        delegate?.showMovieDetails(for: movie)
    }
    
    func cardView(_ view: CardView, didLikeMovie: Bool) {
        let movieId = view.movie.id
        didLikeMovie ? sceneDelegate.addToSkipped(movie: movieId) : sceneDelegate.addToExcluded(movie: movieId)
        
        setStatLabels()
        updateCardView()
    }
    
}

//MARK: - BottomControlsStackViewDelegate

extension SwipeView: BottomControlsStackViewDelegate {
    func handleSkip() {
        if swipeAnimationReady {
            guard let topCard = topCardView else { return }
            sceneDelegate.addToSkipped(movie: topCard.movie.id)
            performSwipeAnimation(topCard: topCard, shouldExclude: false)
            setStatLabels()
        }
    }
    func handleExclude() {
        if swipeAnimationReady {
            guard let topCard = topCardView else { return }
            sceneDelegate.addToExcluded(movie: topCard.movie.id)
            performSwipeAnimation(topCard: topCard, shouldExclude: true)
            setStatLabels()
        }
    }
    func handleAddWatchlist() {
        guard let topCard = topCardView else { return }
        sceneDelegate.addToWatchlist(movie: topCard.movie.id)
        sceneDelegate.userWatchlist.append(topCard.movie)
        setStatLabels()
        updateCardView()
    }
    func handleShowFilter() {
        delegate?.showFilter()
    }
}
