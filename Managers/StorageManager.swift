//
//  StorageManager.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 2/14/23.
//

//import Foundation
//
//import Foundation
//import FirebaseStorage
//
///// Object to interface with firebase storage
//final class StorageManager {
//    static let shared = StorageManager()
//
//    private init() {}
//
//    private let storage = Storage.storage().reference()
//
//    public func profilePictureURL(for uuid: String, completion: @escaping (URL?) -> Void) {
//        self.db.collection("users").document(uuid).getDocument { (document, error) in
//            if error == nil, let data = document?.data(), let imageString = data["image"] as? String {
//                if let url = URL(string: imageString) {
//                    completion(url)
//                    return
//                }
//            }
//            completion(nil)
//        }
//    }
//}

