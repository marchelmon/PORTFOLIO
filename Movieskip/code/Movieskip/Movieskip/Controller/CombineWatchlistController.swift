//
//  CombineWatchlistController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-19.
//

import UIKit

private let cellIdentifier = "FriendCell"

protocol CombineWatchlistDelegate: class {
    func goToRegister()
}

class CombineWatchlistController: UIViewController {
    
    //MARK: - Properties
    
    private let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    weak var delegate: CombineWatchlistDelegate?
    
    private var selectedFriends = [User]()
    
    private let matchingResultsView = MatchingResultsView()
    private let shouldRegisterView = ShouldRegisterView()

    private let friendsLabel: UILabel = {
        let label = UILabel()
        label.text = "Friends"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let friendsTable: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        return table
    }()
    
    private let friendsView = UIView()
    
    private let matchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.setTitle("Combine watchlists", for: .normal)
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(showMatchingResults), for: .touchUpInside)
        return button
    }()
    
    private let backFromResultsButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: imageConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(showFriendsView), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shouldRegisterView.delegate = self
        
        friendsTable.delegate = self
        friendsTable.dataSource = self
        friendsTable.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        configureUI()
        configureAndDisplayFriends()
        
    }
    
    //MARK: - Actions
    
    @objc func handleDone() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleRegister() {
        delegate?.goToRegister()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Combine watchlist with friends"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        sceneDelegate.user == nil ? showRegisterContent() : showFriendsView()
        
    }
    
    func configureAndDisplayFriends() {
        if sceneDelegate.userFriends.count == 0 {
            guard let allUsers = sceneDelegate.allUsers else { return }
            guard let user = sceneDelegate.user else { return }

            user.friendIds.forEach { friendId in
                let friendIndex = allUsers.firstIndex { user -> Bool in
                    return user.uid == friendId
                }
                guard let index = friendIndex else { return }
                sceneDelegate.userFriends.append(allUsers[index])
            }
            sceneDelegate.userFriends = sceneDelegate.userFriends.sorted { $0.username.compare($1.username) == ComparisonResult.orderedAscending }
        }
        friendsTable.reloadData()
    }
    
    @objc func showFriendsView() {
        clearView()
        friendsView.isHidden = false
        
        friendsView.addSubview(friendsLabel)
        friendsLabel.anchor(top: friendsView.topAnchor, left: friendsView.leftAnchor)
        
        friendsView.addSubview(matchButton)
        matchButton.anchor(left: friendsView.leftAnchor, bottom: friendsView.bottomAnchor, right: friendsView.rightAnchor, paddingBottom: 20, height: 45)
        
        friendsView.addSubview(friendsTable)
        friendsTable.anchor(top: friendsLabel.bottomAnchor, left: friendsView.leftAnchor, bottom: matchButton.topAnchor, right: friendsView.rightAnchor, paddingTop: 15, paddingBottom: 20)
        
        view.addSubview(friendsView)
        friendsView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 30, paddingRight: 20)
        
    }
    
    func showRegisterContent() {
        clearView()
        shouldRegisterView.isHidden = false
        
        view.addSubview(shouldRegisterView)
        shouldRegisterView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 250, paddingLeft: 20, paddingRight: 20, height: 200)
    }
    
    @objc func showMatchingResults() {
        clearView()
        matchingResultsView.isHidden = false
        backFromResultsButton.isHidden = false
        
        matchingResultsView.delegate = self
        matchingResultsView.friends = selectedFriends
        
        view.addSubview(backFromResultsButton)
        backFromResultsButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        
        view.addSubview(matchingResultsView)
        matchingResultsView.anchor(top: backFromResultsButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                   right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 30, paddingRight: 20)
        
    }
    
    //MARK: - Helpers
    
    func clearView() {
        friendsView.isHidden = true
        shouldRegisterView.isHidden = true
        matchingResultsView.isHidden = true
        backFromResultsButton.isHidden = true
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension CombineWatchlistController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sceneDelegate.user?.friendIds.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let friend = sceneDelegate.userFriends[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = friend.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let friend = sceneDelegate.userFriends[indexPath.row]
       
        if selectedFriends.contains(where: { return $0.uid == friend.uid }) {
            let friendIndex = selectedFriends.firstIndex { selectedFriend -> Bool in
                if selectedFriend.uid == friend.uid {
                    return true
                }
                return false
            }
            if let friendIndex = friendIndex { selectedFriends.remove(at: friendIndex) }
            cell?.accessoryType = .none
        } else {
            selectedFriends.append(friend)
            cell?.accessoryType = .checkmark
        }
        tableView.reloadData()
    }
    
}

//MARK: - MatchingResultsViewDelegate

extension CombineWatchlistController: MatchingResultsViewDelegate {
    func tablePresentMovieDetails(movie: Movie) {
        let controller = DetailsController(movie: movie)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}


//MARK: - ShouldRegisterDelegate

extension CombineWatchlistController: ShouldRegisterDelegate {
    func goToRegister() {
        delegate?.goToRegister()
    }
}

