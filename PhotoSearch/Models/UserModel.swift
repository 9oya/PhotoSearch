//
//  SponsorModel.swift
//  PhotoSearch
//
//  Created by Eido Goya on 2020/10/27.
//

import Foundation

struct UserModel: Codable {
    let id: String
    let updated_at: String?
    let username: String
    let name: String
    let first_name: String
    let last_name: String
    let twitter_username: String?
    let portfolio_url: String?
    let bio: String?
    let location: String?
    let links: [String: String]
    let profile_image: [String: String]
    let instagram_username: String?
    let total_collections: Int
    let total_likes: Int
    let total_photos: Int
    let accepted_tos: Bool
}
