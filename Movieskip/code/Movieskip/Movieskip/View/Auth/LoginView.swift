//
//  LoginView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-08.
//

import UIKit
import Firebase

class LoginView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: EmailAuthDelegate?
    
    private let email = CustomTextField(placeholder: "Email")
    private let password = CustomTextField(placeholder: "Password")

    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let showResetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Forgot password?",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 15)]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(showResetPassword), for: .touchUpInside)

        return button
    }()
    
    private let showRegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(showRegister), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(showResetPasswordButton)
        showResetPasswordButton.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 25)
        
        addSubview(showRegisterButton)
        showRegisterButton.anchor(left: leftAnchor, bottom: showResetPasswordButton.topAnchor, right: rightAnchor, paddingBottom: 150)
        
        addSubview(loginButton)
        loginButton.anchor(left: leftAnchor, bottom: showRegisterButton.topAnchor, right: rightAnchor, paddingLeft: 40, paddingBottom: 10, paddingRight: 40)
        
        addSubview(password)
        password.anchor(left: leftAnchor, bottom: loginButton.topAnchor, right: rightAnchor, paddingBottom: 15)
        
        addSubview(email)
        email.anchor(left: leftAnchor, bottom: password.topAnchor, right: rightAnchor, paddingBottom: 12)
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func showRegister() {
        delegate?.showRegister()
    }
    
    @objc func showResetPassword() {
        delegate?.showResetPassword()
    }

    @objc func handleLogin() {
        guard let email = email.text else { return }
        guard let password = password.text else { return }
        
        //        let hud = JGProgressHUD(style: .dark)
        //        hud.show(in: view)
        AuthService.logUserIn(withEmail: email, withPassword: password, completion: handleUserLoggedIn)
    }
    
    func handleUserLoggedIn(snapshot: DocumentSnapshot?, error: Error?) {
        if let error = error {
            if let errorCode = AuthErrorCode(rawValue: error._code) {
                //hud.dismiss
                var errorText = ""
                switch errorCode.rawValue {
                case 17007:
                    errorText = "The email is already in use"
                case 17008:
                    errorText = "Please enter a valid email address"
                case 17009:
                    errorText = "The password is not correct"
                case 17010:
                    errorText = "You've made too many attempts to login. Restore your password or try again later"
                case 17011:
                    errorText = "No user found with this email"
                case 17012:
                    errorText = "Please log in with the same auth method as when you created your account "
                default:
                    errorText = "An unknown error occured: please try closing the app and starting again"
                }
                self.delegate?.showAlert(text: errorText, alertAction: nil)

            }
            return
        }
        if let snapshot = snapshot {
            if let userData = snapshot.data() {
                self.delegate?.handleLogin(user: User(dictionary: userData))
            }
        }
    }
    
}
