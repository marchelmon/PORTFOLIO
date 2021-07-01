//
//  HomeNavigationStack.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit

protocol NavigationButtonsDelegate: class {
    func shouldShowSwipe()
    func shouldShowWatchlist()
    func shouldShowUser()
}

class NavigationButtons: UIStackView {
    
    //MARK: - Properties
    
    weak var delegate: NavigationButtonsDelegate?
    
    private let watchlistImage: UIImage? = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "text.badge.star", withConfiguration: imageConfig)
        return image
    }()
    
    private let userImage: UIImage? = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "person", withConfiguration: imageConfig)
        return image
    }()
    
    private let swipeImage: UIImage? = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "film", withConfiguration: imageConfig)
        return image
    }()

    private lazy var swipeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(swipeImage?.withTintColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShowSwipe), for: .touchUpInside)
        return button
    }()
    
    private lazy var watchlistButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(watchlistImage?.withTintColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShowWatchlist), for: .touchUpInside)
        return button
    }()
    
    private lazy var userButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(userImage?.withTintColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShowUser), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        [watchlistButton, UIView(), swipeButton, UIView(), userButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
    
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    //MARK: - Actions
    
    func clearActiveIcons() {
        watchlistButton.setImage(watchlistImage?.withTintColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        userButton.setImage(userImage?.withTintColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        swipeButton.setImage(swipeImage?.withTintColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
    }
    
    @objc func handleShowSwipe() {
        clearActiveIcons()
        swipeButton.setImage(swipeImage?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal), for: .normal)
        delegate?.shouldShowSwipe()
    }
    
    @objc func handleShowWatchlist() {
        clearActiveIcons()
        watchlistButton.setImage(watchlistImage?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal), for: .normal)
        delegate?.shouldShowWatchlist()
    }
    
    @objc func handleShowUser() {
        clearActiveIcons()
        userButton.setImage(userImage?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal), for: .normal)
        delegate?.shouldShowUser()
    }
    
}
