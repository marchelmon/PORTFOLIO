//
//  EmailAuthController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-05.
//

import UIKit
import Firebase

protocol EmailAuthDelegate: class {
    func showLogin()
    func showRegister()
    func showResetPassword()
    func handleLogin(user: User)
    func handleRegister()
    func showAlert(text: String, alertAction: UIAlertAction?)
}

class EmailAuthController: UIViewController {
    
    //MARK: - Properties
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    weak var delegate: AuthenticationDelegate?
    
    private let loginView = LoginView()
    private let registerView = RegisterView()
    private let resetPasswordView = ResetPasswordView()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: imageConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(goToLoginController), for: .touchUpInside)
        button.setDimensions(height: 50, width: 50)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.delegate = self
        registerView.delegate = self
        resetPasswordView.delegate = self
        
        registerView.isHidden = true
        resetPasswordView.isHidden = true
        
        configureGradientLayer()
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        
        view.addSubview(loginView)
        loginView.anchor(top: backButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 30, paddingRight: 30)
        
        view.addSubview(registerView)
        registerView.anchor(top: backButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 30, paddingRight: 30)
        
        view.addSubview(resetPasswordView)
        resetPasswordView.anchor(top: backButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 30, paddingRight: 30)
        
    }
    
    //MARK: - Actions
    
    @objc func goToLoginController() {
        navigationController?.popViewController(animated: true)
    }

}

//MARK: - EmailAuthDelegate

extension EmailAuthController: EmailAuthDelegate {
    
    func showLogin() {
        registerView.isHidden = true
        resetPasswordView.isHidden = true
        loginView.isHidden = false
    }
    
    func showRegister() {
        resetPasswordView.isHidden = true
        loginView.isHidden = true
        registerView.isHidden = false
    }
    
    func showResetPassword() {
        loginView.isHidden = true
        registerView.isHidden = true
        resetPasswordView.isHidden = false
    }
    
    func handleLogin(user: User) {
        sceneDelegate.setUser(user: user)
        delegate?.authenticationComplete()
    }
    
    func handleRegister() {
        delegate?.authenticationComplete()
    }
    
    func showAlert(text: String, alertAction: UIAlertAction?) {
        
        let action = alertAction != nil ? alertAction! : UIAlertAction(title: "OK", style: .default, handler: nil)
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
