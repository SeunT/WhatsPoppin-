//
//  ProfileHeaderViewModel.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 2/14/23.
//

import Foundation
import Foundation

enum ProfileButtonType {
    case edit
    case follow(isFollowing: Bool)
}

struct ProfileHeaderViewModel {
    let profilePictureUrl: URL?
    let followerCount: Int
    let followingCount: Int
    let buttonType: ProfileButtonType
    let name: String?
    let bio: String?
}
