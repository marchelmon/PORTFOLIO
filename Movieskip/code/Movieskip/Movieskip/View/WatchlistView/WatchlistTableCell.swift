//
//  WatchlistTableCell.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-16.
//

import UIKit

class WatchlistTableCell: UITableViewCell {
        
    //MARK: - Properties
    
    let poster: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let movieTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let rating: UIButton = {
        let button = UIButton(type: .system)
        let image = K.WATCHLIST_ICON?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 14))
        button.setImage(image, for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    let headerString: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let genres: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
                
        addSubview(poster)
        poster.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, width: 120 / 1.5, height: 120)
        
        addSubview(headerString)
        headerString.anchor(top: topAnchor, left: poster.rightAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 15)
        
        addSubview(rating)
        rating.anchor(top: headerString.bottomAnchor, left: poster.rightAnchor, paddingTop: 5, paddingLeft: 15)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func createHeaderString(title: String, releaseYear: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(
            string: "\(title)  ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 20),
                .foregroundColor: UIColor.black
            ]
        )
        attributedText.append(
            NSAttributedString(
                string: releaseYear,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18),
                    .foregroundColor: UIColor.darkGray
                ]
            )
        )
        return attributedText
    }
    
    
}
