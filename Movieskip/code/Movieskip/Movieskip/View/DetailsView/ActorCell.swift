//
//  ActorCell.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-24.
//

import UIKit

class ActorCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var actor: Actor! {
        didSet {
            print("DID SET CELL")
            if let profileImage = actor.photoPath {
                profileImageView.sd_setImage(with: profileImage)
                nameLabel.text = actor.name
            } else {
                profileImageView.image = #imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal)
                nameLabel.text = "John Doe"
            }
        }
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.setDimensions(height: 100, width: 100)
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, nameLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 6
        
        addSubview(stack)
        stack.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

