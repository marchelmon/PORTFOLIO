//
//  FailedAuthMessageView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-03.
//

import UIKit

class FailedAuthMessageView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        font = UIFont.boldSystemFont(ofSize: 18)
        textColor = .white
        backgroundColor = UIColor(white: 0.5, alpha: 0.0)
        alpha = 0
        layer.cornerRadius = 10        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
