//
//  WatchlistCollectionCell.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-19.
//

import UIKit

class WatchlistCollectionCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    let poster: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 5))
        
        let stack = UIStackView(arrangedSubviews: [ poster, spacer])
        
        addSubview(stack)
        stack.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
