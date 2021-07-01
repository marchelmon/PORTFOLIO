//
//  FriendsView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-27.
//

import UIKit
import Firebase

private let cellIdentifier = "FriendsCell"

protocol FriendsDelegate: class {
    func friendsGoToRegister()
}

class FriendsView: UIView {
    
    //MARK: - Properties

    private let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    weak var delegate: FriendsDelegate?
    
    var usersToDisplay = [User]()
        
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Find friends"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 15
        tf.layer.borderWidth = 2
        tf.layer.borderColor = K.MAIN_COLOR.cgColor
        tf.leftViewMode = .always
        let leftView = UIView()
        leftView.setDimensions(height: 30, width: 38)
        let leftViewImage = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withTintColor(K.MAIN_COLOR, renderingMode: .alwaysOriginal))
        leftViewImage.setDimensions(height: 28, width: 28)
        leftView.addSubview(leftViewImage)
        leftViewImage.anchor(left: leftView.leftAnchor, paddingLeft: 5)
        tf.leftView = leftView
        tf.addTarget(self, action: #selector(handleSearchTextChanged), for: .editingChanged)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemGroupedBackground
        table.layer.cornerRadius = 5
        table.separatorStyle = .none
        return table
    }()
    
    private let friendsView = UIView()
   
    private let shouldRegisterView = ShouldRegisterView()
    

    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        shouldRegisterView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: cellIdentifier)
                   
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleRegister() {
        delegate?.friendsGoToRegister()
    }
    
    @objc func handleSearchTextChanged(sender: UITextField) {
        guard let text = sender.text else { return }
        
        if text == "" {
            configureAndShowFriends()
        } else if text.count < 3 {
            usersToDisplay = []
            tableView.reloadData()
        } else {
            searchAndShowResults(username: text)
        }
    }
    
    func addFriendToUser(user: User) {
        sceneDelegate.userFriends.append(user)
        sceneDelegate.addFriend(friend: user.uid)
        searchTextField.text = ""
        handleSearchTextChanged(sender: searchTextField)
    }
    
    func removeFriendFromUser(user: User) {
        let index = sceneDelegate.userFriends.firstIndex { friend -> Bool in
            if friend.uid == user.uid { return true }
            return false
        }
        if let index = index { sceneDelegate.userFriends.remove(at: index) }
        sceneDelegate.removeFriend(friendUID: user.uid)
        configureAndShowFriends()
    }
    
    
    //MARK: - Helpers
    
    func searchAndShowResults(username: String) {
        guard let allUsers = sceneDelegate.allUsers else { return }
        guard let authUser = sceneDelegate.user else { return }
        usersToDisplay = []
        
        allUsers.forEach { user in
            if user.username == authUser.username { return }
            if user.username.starts(with: username) { usersToDisplay.append(user) }
        }
        tableView.reloadData()
    }
    
    func configureAndShowFriends() {
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
        usersToDisplay = sceneDelegate.userFriends
        tableView.reloadData()
    }
    
    func configureUI() {
        
        addSubview(friendsView)
        friendsView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        
        friendsView.addSubview(searchTextField)
        searchTextField.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 25, paddingRight: 25, height: 40)
        
        let friendsLabel = UILabel()
        friendsLabel.text = "Friends"
        friendsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        friendsView.addSubview(friendsLabel)
        friendsLabel.anchor(top: searchTextField.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 20)
        
        friendsView.addSubview(tableView)
        tableView.anchor(top: friendsLabel.bottomAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 10,paddingLeft: 20, paddingBottom: 30, paddingRight: 20)
        
        addSubview(shouldRegisterView)
        shouldRegisterView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 150, paddingLeft: 20, paddingRight: 20)
    }
    
    
    func showFriendsView() {
        shouldRegisterView.isHidden = true
        friendsView.isHidden = false
    }
    
    func showRegisterContent() {
        friendsView.isHidden = true
        shouldRegisterView.isHidden = false
    }
    
}

//MARK: - TableViewDelegate    TableViewDataSource

extension FriendsView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FriendCell
        cell.delegate = self
        
        let user = usersToDisplay[indexPath.row]
        cell.user = user
        
        cell.friendButton.setImage(cell.addFriendImage, for: .normal)
        
        let _ = sceneDelegate.userFriends.contains(where: { friend -> Bool in
            if friend.uid == user.uid {

                cell.friendButton.setImage(cell.removeFriendImage, for: .normal)
                return true

            } else {

                cell.friendButton.setImage(cell.addFriendImage, for: .normal)
                return false
            }
        })
                
        cell.usernameLabel.text = user.username
        cell.watchlistCount.text = String(user.watchListCount)
        cell.excludeCount.text = String(user.excludedCount)
        return cell
    }
}

//MARK: - FriendCellDelegate

extension FriendsView: FriendCellDelegate {

    func addFriend(cell: FriendCell) {
        guard let user = cell.user else { return }
                
        addFriendToUser(user: user)
        
        cell.friendButton.setImage(cell.removeFriendImage, for: .normal)

    }
    
    func removeFriend(cell: FriendCell) {
        guard let user = cell.user else { return }
        
        removeFriendFromUser(user: user)
        
        cell.friendButton.setImage(cell.addFriendImage, for: .normal)
    }
}


//MARK: - ShoudlRegisterDelegate

extension FriendsView: ShouldRegisterDelegate {
    func goToRegister() {
        delegate?.friendsGoToRegister()
    }
}
