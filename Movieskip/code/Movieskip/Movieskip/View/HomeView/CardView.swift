//
//  CardView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit
import SDWebImage


enum SwipeDirection: Int {
    case left = -1
    case right = 1
}

protocol CardViewDelegate: class {
    func cardView(_ view: CardView, wantsToShowDetailsFor movie: Movie)
    func cardView(_ view: CardView, didLikeMovie: Bool)
}
    
class CardView: UIView {
    
    //MARK: - Properties
    
    let movie: Movie
    weak var delegate: CardViewDelegate?
    
    private let gradientLayer = CAGradientLayer()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShowMovieDetails), for: .touchUpInside)
        return button
    }()
    
    private lazy var ratingLabel:UIButton = {
        let rating = UIButton(type: .system)
        rating.isEnabled = false
        rating.setTitle(" \(movie.rating)", for: .normal)
        let image = K.WATCHLIST_ICON?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 14))
        rating.setImage(image, for: .normal)
        rating.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        rating.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return rating
    }()
    
    //MARK: - Lifecycle
    
    init(movie: Movie) {
        self.movie = movie
        super.init(frame: .zero)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = .white
        
        imageView.sd_setImage(with: movie.posterPath)
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        configureGestureRecognizers()
        configureGradientLayer()
        
        addSubview(ratingLabel)
        ratingLabel.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 12, paddingBottom: 12)

        addSubview(infoButton)
        infoButton.setDimensions(height: 35, width: 35)
        infoButton.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 12, paddingRight: 12)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    //MARK: - Actions
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            superview?.subviews.forEach({ $0.layer.removeAllAnimations() })
        case .changed:
            pancard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default: break
        }
    }
    
    @objc func handleShowMovieDetails() {
        TmdbService.fetchMovieWithDetails(withId: movie.id) { movie in
            self.delegate?.cardView(self, wantsToShowDetailsFor: movie)
        }
    }
    
    //MARK: - Helpers
    
    func pancard(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 100
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
    }
        
    func resetCardPosition(sender: UIPanGestureRecognizer) {
        let direction: SwipeDirection = sender.translation(in: nil).x > 100 ? .right : .left
        let shouldDismissCard = abs(sender.translation(in: nil).x) > 100
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            
            if shouldDismissCard {
                let xtranslation = CGFloat(direction.rawValue) * 1000
                let offScreenTransform = self.transform.translatedBy(x: xtranslation, y: 0)
                self.transform = offScreenTransform
            } else {
                self.transform = .identity
            }
        }) { _ in
            if shouldDismissCard {
                let didLike = direction == .right
                self.delegate?.cardView(self, didLikeMovie: didLike)
            }
        }
    }
    
    func configureGestureRecognizers() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleShowMovieDetails))
        addGestureRecognizer(tap)
    }
    
    func configureGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
}
