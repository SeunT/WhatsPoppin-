//
//  UserInfo.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 2/14/23.
//

import Foundation
struct UserInfo: Codable {
    let name: String
    let bio: String
    
    init?(with data: [String: Any]) {
            guard let name = data["name"] as? String,
                let bio = data["bio"] as? String else {
                    return nil
            }

            self.name = name
            self.bio = bio
        }
}
