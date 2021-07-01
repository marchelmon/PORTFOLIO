//
//  UserView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-17.
//


import UIKit
import Firebase

protocol UserViewDelegate: class {
    func userPressedLogout()
    func userPressedRegister()
}

class UserView: UIView {
            
    //MARK: - Properties
        
    private let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    weak var delegate: UserViewDelegate?
    
    private let friendsView = FriendsView()
    private let profileView = ProfileView()
    
    private let friendsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Friends", for: .normal)
        button.setTitleColor(K.MAIN_COLOR, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(showFriends), for: .touchUpInside)
        return button
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Profile", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(showProfile), for: .touchUpInside)
        return button
    }()
        
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        profileView.delegate = self
        friendsView.delegate = self
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func showFriends() {
        friendsView.isHidden = false
        profileView.isHidden = true
        
        friendsButton.setTitleColor(K.MAIN_COLOR, for: .normal)
        profileButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
    }

    @objc func showProfile() {
        friendsView.isHidden = true
        profileView.isHidden = false
        
        profileButton.setTitleColor(K.MAIN_COLOR, for: .normal)
        friendsButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
                
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        profileView.configureUserDetails()
        friendsView.configureAndShowFriends()
        
        sceneDelegate.user != nil ? profileView.showProfileView() : profileView.showRegisterContent()
        sceneDelegate.user != nil ? friendsView.showFriendsView() : friendsView.showRegisterContent()

        let topButtonStack = UIStackView(arrangedSubviews: [UIView(), friendsButton, profileButton, UIView()])
        topButtonStack.backgroundColor = .white
        topButtonStack.distribution = .equalSpacing
        
        addSubview(topButtonStack)
        topButtonStack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 70)
        
        addSubview(friendsView)
        friendsView.anchor(top: topButtonStack.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        addSubview(profileView)
        profileView.anchor(top: topButtonStack.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        showFriends()
    }
 
}

//MARK: - ProfileDelegate

extension UserView: ProfileDelegate {
    func handleLogout() {
        delegate?.userPressedLogout()
    }
    
    func profileGoToRegister() {
        delegate?.userPressedRegister()
    }
}

//MARK: - FriendsDelegate

extension UserView: FriendsDelegate {
    func friendsGoToRegister() {
        delegate?.userPressedRegister()
    }
}

