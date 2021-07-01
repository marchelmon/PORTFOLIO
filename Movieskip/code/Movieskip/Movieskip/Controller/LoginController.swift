//
//  LoginController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-25.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

protocol AuthenticationDelegate: class {
    func authenticationComplete()
}

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate

    weak var delegate: AuthenticationDelegate?
    
    private let googleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(#colorLiteral(red: 0.6176958476, green: 0.05836011096, blue: 0.1382402272, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("       Continue with google", for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(signInGoogle), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "google-icon"), for: .normal)
        button.imageView?.anchor(top: button.topAnchor, left: button.leftAnchor, bottom: button.bottomAnchor, paddingTop: 10, paddingLeft: 6, paddingBottom: 10, width: 40)
        button.titleLabel?.anchor(right: button.rightAnchor, paddingRight: 10)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let facebookButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(#colorLiteral(red: 0.09664548344, green: 0.05595414365, blue: 0.5788586612, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("       Continue with facebook", for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(signInFacebook), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "fb-icon"), for: .normal)
        button.imageView?.anchor(top: button.topAnchor, left: button.leftAnchor, bottom: button.bottomAnchor, paddingTop: 10, paddingLeft: 6, paddingBottom: 10, width: 40)
        button.titleLabel?.anchor(right: button.rightAnchor, paddingRight: 10)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let emailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("       Continue with email", for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(showEmailAuth), for: .touchUpInside)
        button.setImage(UIImage(systemName: "envelope.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        button.imageView?.anchor(top: button.topAnchor, left: button.leftAnchor, bottom: button.bottomAnchor, paddingTop: 10, paddingLeft: 6, paddingBottom: 10, width: 40)
        button.titleLabel?.anchor(right: button.rightAnchor, paddingRight: 10)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let signUpLaterButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Continue without login",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleSkipLogin), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        configureGradientLayer()
        configureUI()
    }
    
    //MARK: - Actions
    
    @objc func signInGoogle() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func signInFacebook() {
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: [], viewController: self) { result in
            switch result {
            case .success(token: let token):
                if let token = token.token?.tokenString {
                    let credential = FacebookAuthProvider.credential(withAccessToken: token)
                    self.socialSignIn(credential: credential)
                }
            case .cancelled:
                print("FB cancel")
            case .failed(_):
                self.showAlert(text: "DEBUG ERROR: FACEBOOK LOGIN FAILED") //TODO: ändra alert?
            }
        }
    }
    
    @objc func handleSkipLogin() {
        UserDefaults.standard.set(true, forKey: "skippedLogin")
        sceneDelegate.fetchLocalUser()
        delegate?.authenticationComplete()
    }
    
    
    @objc func showEmailAuth() {
        let controller = EmailAuthController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleUserLoggedIn(snapshot: DocumentSnapshot?, error: Error?) {
        if let error = error {
            showAlert(text: "handleuserloggedIn: \(error.localizedDescription)") //TODO: ändra alert?
        }
        if let snapshot = snapshot {
            if let userData = snapshot.data() {
                self.sceneDelegate.setUser(user: User(dictionary: userData))
            }
        }
        //hud.dismiss
        self.delegate?.authenticationComplete()
    }
    
    func socialSignIn(credential: AuthCredential) {
        AuthService.socialSignIn(credential: credential) { error in
            if let error = error {
                self.showAlert(text: error.localizedDescription)
                return
            }
            if let user = Auth.auth().currentUser {
                AuthService.fetchLoggedInUser(uid: user.uid, completion: self.handleUserLoggedIn)
            } else {
                self.showAlert(text: "Something went wrong, please try again or restart the app")
            }
        }
    }
    
    //MARK: - Helpers
    
    func showAlert(text: String) {
        let alert = UIAlertController(title: text, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func configureUI() {
        
        view.addSubview(signUpLaterButton)
        signUpLaterButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                                 paddingLeft: 32, paddingBottom: 20, paddingRight: 32)
        
        let buttonStack = UIStackView(arrangedSubviews: [emailButton, facebookButton, googleButton])
        buttonStack.spacing = 15
        buttonStack.axis = .vertical
        
        view.addSubview(buttonStack)
        buttonStack.anchor(left: view.leftAnchor, bottom: signUpLaterButton.topAnchor, right: view.rightAnchor,
                           paddingLeft: 32, paddingBottom: 160, paddingRight: 32)
   
    }
    
}

//MARK: - GIDSignInDelegate Google

extension LoginController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {

        if error != nil { return }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
     
        socialSignIn(credential: credential)
    }
}

