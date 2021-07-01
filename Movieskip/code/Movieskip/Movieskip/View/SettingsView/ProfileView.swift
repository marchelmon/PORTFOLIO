//
//  ProfileView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-28.
//

import UIKit
import Firebase


protocol ProfileDelegate: class {
    func handleLogout()
    func profileGoToRegister()
}

class ProfileView: UIView {
    
    //MARK: - Properties
        
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    weak var delegate: ProfileDelegate?
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = K.MAIN_COLOR
        return label
    } ()
    
    private let userDetailsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let tmdbImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "tmdb-logo").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFill
        return iv
    } ()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    private var restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore purchase", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.addTarget(self, action: #selector(handleRestore), for: .touchUpInside)
        return button
    }()
    
    private let shouldRegisterView = ShouldRegisterView()
    
    lazy var watchlistCountLabel = createCountLabel(count: sceneDelegate.user?.watchListCount ?? 0)
    lazy var excludedCountLabel = createCountLabel(count: sceneDelegate.user?.excludedCount ?? 0)
    lazy var friendsCountLabel = createCountLabel(count: sceneDelegate.user?.friendIds.count ?? 0)

    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        shouldRegisterView.delegate = self
        
        configureUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleRegister() {
        delegate?.profileGoToRegister()
    }
    
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
    
    @objc func handleRestore() {
        print("Restore purchase!")
    }
    
    //MARK: - Helpers
    
    func createCountLabel(count: Int) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = K.MAIN_COLOR
        label.text = String(count)
        return label
    }
    
    func configureUserDetails() {
        usernameLabel.text = "\(sceneDelegate.user?.username ?? "John Doe") "
        watchlistCountLabel.text = "\(sceneDelegate.user?.watchListCount ?? 0)"
        excludedCountLabel.text = "\(sceneDelegate.user?.excludedCount ?? 0)"
        friendsCountLabel.text = "\(sceneDelegate.user?.friendIds.count ?? 0)"
    }
    
    func configureUI() {
        addSubview(userDetailsView)
        userDetailsView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 200)
        
        userDetailsView.addSubview(usernameLabel)

        userDetailsView.addSubview(watchlistCountLabel)
        userDetailsView.addSubview(excludedCountLabel)
        userDetailsView.addSubview(friendsCountLabel)
        
        usernameLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 20)
        watchlistCountLabel.anchor(top: usernameLabel.bottomAnchor, right: rightAnchor, paddingTop: 10, paddingRight: 20)
        excludedCountLabel.anchor(top: usernameLabel.bottomAnchor, right: watchlistCountLabel.leftAnchor, paddingTop: 10, paddingRight: 80)
        friendsCountLabel.anchor(top: usernameLabel.bottomAnchor, right: excludedCountLabel.leftAnchor, paddingTop: 10, paddingRight: 80)
        
        addSubview(shouldRegisterView)
        shouldRegisterView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 150, paddingLeft: 20, paddingRight: 20)
        
        showBottomStack()
    }
    
    func showProfileView() {
        shouldRegisterView.isHidden = true
        userDetailsView.isHidden = false
        logoutButton.isHidden = false
        restoreButton.isHidden = false
    }
    
    func showRegisterContent() {
        userDetailsView.isHidden = true
        shouldRegisterView.isHidden = false
        logoutButton.isHidden = true
        restoreButton.isHidden = true
    }
    
    func showBottomStack() {
        addSubview(tmdbImage)
        tmdbImage.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingLeft: 30, paddingBottom: 20, paddingRight: 30)
        
        let sourceLabel = UILabel()
        sourceLabel.text = "Content source"
        sourceLabel.font = UIFont.systemFont(ofSize: 15)
        sourceLabel.textColor = .lightGray
        
        addSubview(sourceLabel)
        sourceLabel.anchor(left: leftAnchor, bottom: tmdbImage.topAnchor, paddingLeft: 20, paddingBottom: 10)
        
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, bottom: sourceLabel.topAnchor, right: rightAnchor, paddingBottom: 20, height: 60)
        
        addSubview(restoreButton)
        restoreButton.anchor(left: leftAnchor, bottom: logoutButton.topAnchor, right: rightAnchor, paddingBottom: 10, height: 60)
    }
    
}

//MARK: - ShouldRegisterDelegate

extension ProfileView: ShouldRegisterDelegate {
    func goToRegister() {
        delegate?.profileGoToRegister()
    }
}
