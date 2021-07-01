//
//  MovieskipController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-15.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit

class MovieskipController: UIViewController {
    
    //MARK: - Properties
    
    private let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    private let topStack = NavigationButtons()
    
    let swipeView = SwipeView()
    let watchlistView = WatchlistView()
    let userView = UserView()
        
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSwipeView()
        topStack.handleShowSwipe()
        
        configureUser()
        configureUI()
        
        topStack.delegate = self
        swipeView.delegate = self
        watchlistView.delegate = self
        userView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        userView.configureUI()
    }
    
    //MARK: - Actions

    func configureUser() {
        if let user = sceneDelegate.user {
            swipeView.fetchFilterAndMovies()
            watchlistView.fetchAndConfigureMovies()
            if user.username == "" { presentUsernameSelectionView() }
        } else {
            
            if let loggedInUser = Auth.auth().currentUser {
            
                AuthService.fetchLoggedInUser(uid: loggedInUser.uid) { (snapshot, error) in
                    if let error = error {
                        self.swipeViewAlert(text: "Error fetching user data: \(error.localizedDescription)", alertAction: nil)
                        return
                    }
                    if let snapshot = snapshot {
                        if let userData = snapshot.data() {
                            self.sceneDelegate.user = User(dictionary: userData)
                            if self.sceneDelegate.user?.username == "" { self.presentUsernameSelectionView() }
                            self.swipeView.fetchFilterAndMovies()
                            self.watchlistView.fetchAndConfigureMovies()
                        }
                    }
                    self.userView.configureUI()
                }
            } else {
                let userHasSkippedLoginPreviously = UserDefaults.standard.bool(forKey: "skippedLogin")
                if  !userHasSkippedLoginPreviously {
                    presentLoginController()
                } else {
                    if sceneDelegate.localUser == nil { sceneDelegate.fetchLocalUser() }
                    swipeView.fetchFilterAndMovies()
                    watchlistView.fetchAndConfigureMovies()
                }
            }
        }
        userView.configureUI()
    }
    
    func showSwipeView() {
        clearView()
        swipeView.isHidden = false
    }
    
    func showWatchlistView() {
        clearView()
        watchlistView.displayMovies()
        watchlistView.isHidden = false
        
    }
    
    func showUserView() {
        clearView()
        userView.isHidden = false
        userView.configureUI()
    }
    
    func clearView() {
        swipeView.isHidden = true
        userView.isHidden = true
        watchlistView.isHidden = true
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
            sceneDelegate.user = nil
            sceneDelegate.userFriends = []
        } catch {
            showAlert(text: "Failed to log out. Try again after restarting the app", alertAction: nil)
        }
    }
    
    func presentUsernameSelectionView() {
        let controller = UsernameController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalTransitionStyle = .flipHorizontal
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func showAlert(text: String, alertAction: UIAlertAction?) {
        
        let action = alertAction != nil ? alertAction! : UIAlertAction(title: "OK", style: .default, handler: nil)
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(topStack)
        topStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        view.addSubview(swipeView)
        swipeView.anchor(top: topStack.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 5, width: view.frame.width)

        view.addSubview(watchlistView)
        watchlistView.anchor(top: topStack.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 5, width: view.frame.width)

        view.addSubview(userView)
        userView.anchor(top: topStack.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 5, width: view.frame.width)
        
    }
    
}

//MARK: - SwipeViewDelegate

extension MovieskipController: SwipeViewDelegate {
    func showMovieDetails(for movie: Movie) {
        let controller = DetailsController(movie: movie)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    func showFilter() {
        let controller = FilterController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func presentSelectUsername() {
        presentUsernameSelectionView()
    }
    func presentLogin() {
        presentLoginController()
    }
    func swipeViewAlert(text: String, alertAction: UIAlertAction?) {
        showAlert(text: text, alertAction: alertAction)
    }
}

//MARK: - FilterControllerDelegate

extension MovieskipController: FilterControllerDelegate {
    func filterController(controller: FilterController, wantsToUpdateFilter filter: Filter) {
        FilterService.filter = filter
        swipeView.moviesToDisplay = []
        swipeView.fetchMovies(filter: filter)
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK: - AuthenticationDelegate

extension MovieskipController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true) {
            self.swipeView.setStatLabels()
            self.watchlistView.fetchAndConfigureMovies()
            if self.sceneDelegate.user?.username == "" {
                self.presentUsernameSelectionView()
            }
            FilterService.filter.page = 1
            self.swipeView.refillMovies()
        }
    }
}

//MARK: - WatchlistViewDelegate

extension MovieskipController: WatchlistViewDelegate {
    func goToCombineWatchlist() {
        let controller = CombineWatchlistController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func presentMovieDetails(movie: Movie) {
        let controller = DetailsController(movie: movie)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

//MARK: - UserViewDelegate

extension MovieskipController: UserViewDelegate {
    func userPressedLogout() {
        logout()
    }
    
    func userPressedRegister() {
        presentLoginController()
    }
}

//MARK: - NavigationButtonsDelegate

extension MovieskipController: NavigationButtonsDelegate {
    func shouldShowSwipe() {
        showSwipeView()
    }
    
    func shouldShowWatchlist() {
        showWatchlistView()
    }
    
    func shouldShowUser() {
        showUserView()
    }
}

//MARK: - CombineWatchlistDelegate

extension MovieskipController: CombineWatchlistDelegate {
    func goToRegister() {
        dismiss(animated: true) {
            self.presentLoginController()
        }
    }
}
