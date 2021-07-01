//
//  ShouldRegisterView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-13.
//

import UIKit

protocol ShouldRegisterDelegate: class {
    func goToRegister()
}

class ShouldRegisterView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: ShouldRegisterDelegate?
    
    private let shouldRegisterText: UILabel = {
        let label = UILabel()
        label.text = "The main purpose of this app can only be available with an account. Read more... "
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = K.MAIN_COLOR
        return label
    } ()
        
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(K.MAIN_COLOR, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 3
        button.layer.borderColor = K.MAIN_COLOR.cgColor
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(shouldRegisterText)
        shouldRegisterText.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        
        addSubview(registerButton)
        registerButton.centerX(inView: self)
        registerButton.anchor(top: shouldRegisterText.bottomAnchor, paddingTop: 20, width: 170)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Actions
    
    @objc func handleRegister() {
        delegate?.goToRegister()
    }
    
}
