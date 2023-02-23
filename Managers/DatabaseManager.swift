//
//  DatabaseManager.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 2/14/23.
//

import Foundation
import Foundation
import FirebaseFirestore
import FirebaseMessaging
/// Object to manage database interactions
final class DatabaseManager {

    /// Shared instance
    static let shared = DatabaseManager()

    /// Private constructor
    private init() {}

    /// Database referenec
    private let database = Firestore.firestore()

    /// Find users with prefix
    /// - Parameters:
    ///   - usernamePrefix: Query prefix
    ///   - completion: Result callback
//    public func findUsers(
//        with usernamePrefix: String,
//        completion: @escaping ([User]) -> Void
//    ) {
//        let ref = database.collection("users")
//        ref.getDocuments { snapshot, error in
//            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }),
//                  error == nil else {
//                completion([])
//                return
//            }
//            let subset = users.filter({
//                $0.username.lowercased().hasPrefix(usernamePrefix.lowercased())
//            })
//
//            completion(subset)
//        }
//    }


    /// Follow states that are supported
    enum RelationshipState {
        case follow
        case unfollow
    }

    /// Update relationship of follow for user
    /// - Parameters:
    ///   - state: State to update to
    ///   - targetUsername: Other user username
    ///   - completion: Result callback
    public func updateRelationship(
        state: RelationshipState,
        for targetUuid: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUuid = UserDefaults.standard.string(forKey: "uuid") else {
            completion(false)
            return
        }

        let currentFollowing = database.collection("users")
            .document(currentUuid)
            .collection("following")

        let targetUserFollowers = database.collection("users")
            .document(targetUuid)
            .collection("followers")

        switch state {
        case .unfollow:
            // Remove follower for currentUser following list
            currentFollowing.document(targetUuid).delete()
            // Remove currentUser from targetUser followers list
            targetUserFollowers.document(currentUuid).delete()

            completion(true)
        case .follow:
            // Add follower for requester following list
            currentFollowing.document(targetUuid).setData(["valid": "1"])
            // Add currentUser to targetUser followers list
            
            if let fcmtoken = Messaging.messaging().fcmToken
            {
                targetUserFollowers.document(currentUuid).setData(["valid": "1","fcmtoken": fcmtoken])
            }
            else {
                targetUserFollowers.document(currentUuid).setData(["valid": "1"])
            }

            completion(true)
        }
    }

    /// Get user counts for target usre
    /// - Parameters:
    ///   - username: Username to query
    ///   - completion: Callback
    public func getUserCounts(
        uuid: String,
        completion: @escaping ((followers: Int, following: Int)) -> Void
    ) {
        let userRef = database.collection("users")
            .document(uuid)

        var followers = 0
        var following = 0


        let group = DispatchGroup()
        group.enter()
        group.enter()

        userRef.collection("followers").getDocuments { snapshot, error in
            defer {
                group.leave()
            }

            guard let count = snapshot?.documents.count, error == nil else {
                return
            }
            followers = count
        }

        userRef.collection("following").getDocuments { snapshot, error in
            defer {
                group.leave()
            }

            guard let count = snapshot?.documents.count, error == nil else {
                return
            }
            following = count
        }

        group.notify(queue: .global()) {
            let result = (
                followers: followers,
                following: following
            )
            completion(result)
        }
    }

    /// Check if current user is following another
    /// - Parameters:
    ///   - targetUsername: Other user to check
    ///   - completion: Result callback
    public func isFollowing(targetUuid: String,completion: @escaping (Bool) -> Void)
    {
        //might need to change to using core uuid instead
        guard let currentUuid = UserDefaults.standard.string(forKey: "uuid") else {
            completion(false)
            return
        }

        let ref = database.collection("users")
            .document(targetUuid)
            .collection("followers")
            .document(currentUuid)
        ref.getDocument { snapshot, error in
            guard snapshot?.data() != nil, error == nil else {
                // Not following
                completion(false)
                return
            }
            // following
            completion(true)
        }
    }

    /// Get followers for user
    /// - Parameters:
    ///   - username: Uuid  to query
    ///   - completion: Result callback
    public func followers(for uuid: String, completion: @escaping ([String]) -> Void) {
        let ref = database.collection("users")
            .document(uuid)
            .collection("followers")
        ref.getDocuments { snapshot, error in
            guard let usernames = snapshot?.documents.compactMap({ $0.documentID }), error == nil else {
                completion([])
                return
            }
            completion(usernames)
        }
    }
    /// Find users with prefix
    /// - Parameters:
    ///   - usernamePrefix: Query prefix
    ///   - completion: Result callback
    public func findUsers( with uuid: String, completion: @escaping (String) -> Void
    )
    {
        let ref = database.collection("users").document(uuid)
        
        ref.getDocument { snapshot, error in
                guard let data = snapshot?.data(),
                      let name = data["name"] as? String,
                      error == nil else {
                    completion("")
                    return
                }
                completion(name)
            }
    }
    

    /// Get users that parameter username follows
    /// - Parameters:
    ///   - username: Query uuid
    ///   - completion: Result callback
    public func following(for uuid: String, completion: @escaping ([String]) -> Void) {
        let ref = database.collection("users")
            .document(uuid)
            .collection("following")
        ref.getDocuments { snapshot, error in
            guard let usernames = snapshot?.documents.compactMap({ $0.documentID }), error == nil else {
                completion([])
                return
            }
            completion(usernames)
        }
    }

    // MARK: - User Info

    /// Get user info
    /// - Parameters:
    ///   - username: username to query for
    ///   - completion: Result callback
    public func getUserInfo( uuid: String, completion: @escaping (UserInfo?) -> Void ) {
        
        let ref = database.collection("users")
            .document(uuid)
//            .collection("information")
//            .document("basic")
        ref.getDocument { snapshot, error in
            guard let data = snapshot?.data(), let userInfo = UserInfo(with: data) else {
                completion(nil)
                return
            }
            completion(userInfo)
        }
    }
    
    public func profilePictureURL(for uuid: String, completion: @escaping (URL?) -> Void) {
        database.collection("users").document(uuid).getDocument {
            
            (document, error) in
            if error == nil, let data = document?.data(), let imageString = data["image"] as? String {
                if let url = URL(string: imageString) {
                    completion(url)
                    return
                }
            }
            completion(nil)
        }
    }


}
