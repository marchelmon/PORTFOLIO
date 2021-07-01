//
//  FriendCell.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-02.
//

import UIKit

protocol FriendCellDelegate: class {
    func addFriend(cell: FriendCell)
    func removeFriend(cell: FriendCell)
}

class FriendCell: UITableViewCell {
    
    //MARK: - Properties
    
    weak var delegate: FriendCellDelegate?
    
    var user: User?
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = K.MAIN_COLOR
        return label
    }()
    
    let watchlistCount:  UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
 
    let excludeCount:  UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let friendButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let addFriendImage: UIImage? = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "person.fill.badge.plus", withConfiguration: imageConfig)?.withTintColor(#colorLiteral(red: 0.1793520883, green: 0.2976820872, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        return image
    }()
    
    let removeFriendImage: UIImage? = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "person.fill.badge.minus", withConfiguration: imageConfig)?.withTintColor(#colorLiteral(red: 0.4740568882, green: 0.04478905388, blue: 0.1060938521, alpha: 1), renderingMode: .alwaysOriginal)
        return image
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = UITableViewCell.SelectionStyle.none
        
        friendButton.addTarget(self, action: #selector(toggleFriend), for: .touchUpInside)

        contentView.addSubview(usernameLabel)
        contentView.addSubview(watchlistCount)
        contentView.addSubview(excludeCount)
        
        usernameLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 20)
        watchlistCount.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, paddingLeft: 25)
        excludeCount.anchor(top: usernameLabel.bottomAnchor, left: watchlistCount.rightAnchor, paddingLeft: 15)
        
        contentView.addSubview(friendButton)
        friendButton.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor, paddingRight: 20)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func toggleFriend() {
        guard let image = friendButton.imageView?.image else { return }

        if image == addFriendImage {
            delegate?.addFriend(cell: self)
        } else if image == removeFriendImage {
            delegate?.removeFriend(cell: self)
        }
        
    }
    
}
