//
//  UserDetails.swift
//  ShubamTask
//
//  Created by Shubam Gupta on 24/07/20.
//  Copyright © 2020 Shubam. All rights reserved.
//

import Foundation

// MARK: - UserDetails
struct UserDetails: Codable {
    let userDetails: [UserDetailData]
}

// MARK: - UserDetail
struct UserDetailData: Codable {
    let name: String
    var expand: Bool
    let friends: [Friend]
}

// MARK: - Friend
struct Friend: Codable {
    let name: String
    let image: String
}
