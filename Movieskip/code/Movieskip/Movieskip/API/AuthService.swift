//
//  AuthService.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-07.
//

import Foundation
import Firebase

struct AuthService {
    
    static let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate

    static func logUserIn(withEmail email: String, withPassword password: String, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let data = data {
                K.COLLECTION_USERS.document(data.user.uid).getDocument(completion: completion)
            }
        }
    }
    
    static func registerUser(email: String, password: String, completion: @escaping ((Error?) -> Void)) {
    
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let result = result else { return }
            result.user.sendEmailVerification { error in
                if let error = error {
                    print("ERROR VERIFYING EMAIL: \(error.localizedDescription)")
                }
            }
            
            let uid = result.user.uid
            let localUser = sceneDelegate.localUser
            let data: [String: Any] = [
                "uid": result.user.uid,
                "email": result.user.email ?? "",
                "watchlist": localUser?.watchlist ?? [],
                "excluded": localUser?.excluded ?? [],
                "skipped": localUser?.skipped ?? [],
            ]
            
            let user = User(dictionary: data)
            sceneDelegate.setUser(user: user)
            let userData = user.dictionary
            K.COLLECTION_USERS.document(uid).setData(userData, completion: completion)
        
        }
    }
    
    static func resetUserPassword(email: String, completion: @escaping ((Error?) -> Void)) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    static func socialSignIn(credential: AuthCredential, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(with: credential) { (data, error) in
            if let error = error {
                completion(error)
                return
            }
            if let data = data {
                K.COLLECTION_USERS.document(data.user.uid).getDocument { (snapshot, error) in
            
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    if let snapshot = snapshot {
                        if snapshot.exists {
                            
                            guard let userData = snapshot.data() else { return }
                            let user = User(dictionary: userData)
                            sceneDelegate.setUser(user: user)
                            completion(nil)
                            
                        } else {
                            
                            let localUser = sceneDelegate.localUser
                            let userData: [String: Any] = [
                                "uid": data.user.uid,
                                "email": data.user.email ?? "",
                                "watchlist": localUser?.watchlist ?? [],
                                "excluded": localUser?.excluded ?? [],
                                "skipped": localUser?.skipped ?? [],
                            ]
                            
                            let newUser = User(dictionary: userData)
                            sceneDelegate.setUser(user: newUser)
                            
                            K.COLLECTION_USERS.document(data.user.uid).setData(newUser.dictionary) { error in
                                completion(error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func fetchLoggedInUser(uid: String, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
        K.COLLECTION_USERS.document(uid).getDocument(completion: completion)
    }
    
    static func fetchUserByUsername(username: String, completion: @escaping ((QuerySnapshot?, Error?) -> Void)) {
        K.COLLECTION_USERS.whereField("username", isEqualTo: username).getDocuments(completion: completion)
    }
    
    static func updateUsername(username: String) {

        sceneDelegate.user?.username = username
        
        guard let uid = sceneDelegate.user?.uid else { return }
        K.COLLECTION_USERS.document(uid).updateData(["username" : username])
            
    }
    
    static func fetchAllUsers(completion: @escaping (QuerySnapshot?, Error?) -> Void) {
        K.COLLECTION_USERS.getDocuments(completion: completion)
    }
    
}
