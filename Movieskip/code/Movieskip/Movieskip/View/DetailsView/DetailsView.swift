//
//  DetailsHeaderView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-22.
//

import UIKit


class DetailsView: UIView {
    
    //MARK: - Properties
    
    private let movie: Movie
    
    private let actorCollection = ActorCollection()
    
    let posterImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 7
        iv.clipsToBounds = true
        return iv
    }()

    private let rating: UIButton = {
        let rating = UIButton()
        
        rating.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        rating.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        rating.setImage(UIImage(systemName: "star.fill")?.withTintColor(#colorLiteral(red: 0.9529411793, green: 0.8256965162, blue: 0.1009962625, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        rating.imageView?.setDimensions(height: 30, width: 30)
        return rating
    }()
    
    private let releaseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private let trailerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Watch trailer", for: .normal)
        button.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleShowTrailer), for: .touchUpInside)
        return button
    } ()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let overviewText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 8
        return label
    }()
    
    private let actorsLabel: UILabel = {
        let label = UILabel()
        label.text = "Actors"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    private let actorsList: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Lifecycle
    
    init(movie: Movie) {
        self.movie = movie
        super.init(frame: .zero)
        backgroundColor = .systemGroupedBackground
        frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        
        configureUI()
        configureMovieDataForDisplay(movie: movie)
    
//        addSubview(actorCollection)
//
//        actorCollection.anchor(top: overviewText.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10)
//        actorCollection.actors = movie.actors

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleDismiss() {
        print("SHOULD DISMISS!")
    }
    
    @objc func handleShowTrailer() {
        guard let trailerKey = movie.trailer else { return }
        if let url = URL(string: "\(K.YOUTUBE_STARTING_PATH)\(trailerKey)") {
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        addSubview(posterImage)
        posterImage.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 15, paddingLeft: 15)
        posterImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        posterImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45 * 1.5).isActive = true
        
        addSubview(rating)
        addSubview(releaseLabel)
        addSubview(trailerButton)
        
        rating.anchor(top: safeAreaLayoutGuide.topAnchor, left: posterImage.rightAnchor, paddingTop: 18, paddingLeft: 10)
        releaseLabel.anchor(top: rating.bottomAnchor, left: posterImage.rightAnchor, paddingTop: 4, paddingLeft: 10)
        trailerButton.anchor(top: releaseLabel.bottomAnchor, left: posterImage.rightAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 10, paddingRight: 15)
        
        addSubview(genresLabel)
        genresLabel.anchor(top: trailerButton.bottomAnchor, left: posterImage.rightAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 5)

        addSubview(titleLabel)
        addSubview(overviewText)
        
        titleLabel.anchor(top: posterImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        overviewText.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        
        addSubview(actorsLabel)
        actorsLabel.anchor(top: overviewText.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        addSubview(actorsList)
        actorsList.anchor(top: actorsLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10)
        
    }
    
    
    func configureMovieDataForDisplay(movie: Movie) {
        posterImage.sd_setImage(with: movie.posterPath)
        titleLabel.text = movie.title
        rating.setTitle("  \(movie.rating)/10", for: .normal)
        releaseLabel.text = "\(movie.released)"
        overviewText.text = movie.overview
        
        for (index, genre) in movie.genres.enumerated() {
            if movie.genres.count == index + 1 {
                genresLabel.text?.append("\(genre.name)")
            } else {
                genresLabel.text?.append("\(genre.name), ")
            }
        }
        
        for (index, actor) in movie.actors.enumerated() {
            if movie.actors.count == index + 1 {
                actorsList.text?.append("\(actor.name)")
            } else {
                actorsList.text?.append("\(actor.name), ")
            }
        }
    }
    
}
