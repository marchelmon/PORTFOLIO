//
//  resetPasswordView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-08.
//

import UIKit

class ResetPasswordView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: EmailAuthDelegate?
    
    private let email = CustomTextField(placeholder: "Email")
    
    private let resetPasswordButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Reset password", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    private let showLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go to Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(showLoginButton)
        showLoginButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingBottom: 250)
        
        addSubview(resetPasswordButton)
        resetPasswordButton.anchor(left: leftAnchor, bottom: showLoginButton.topAnchor, right: rightAnchor, paddingLeft: 40, paddingBottom: 10, paddingRight: 40)
        
        addSubview(email)
        email.anchor(left: leftAnchor, bottom: resetPasswordButton.topAnchor, right: rightAnchor, paddingBottom: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func resetPassword() {
        guard let email = email.text else { return }
        if !email.isValidEmail(){
            delegate?.showAlert(text: "Please enter a valid email address", alertAction: nil)
            return
        }
        AuthService.resetUserPassword(email: email) { error in
            if error != nil {
                self.delegate?.showAlert(text: "Something went wrong, check your email or try again", alertAction: nil)
                return
            }
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in self.delegate?.showLogin() })
            self.delegate?.showAlert(text: "Check your email to continue password restoration", alertAction: alertAction)
        }
    }
    
    @objc func showLogin() {
        delegate?.showLogin()
    }
    
}
