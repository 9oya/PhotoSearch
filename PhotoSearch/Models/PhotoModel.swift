//
//  PhotoModel.swift
//  PhotoSearch
//
//  Created by Eido Goya on 2020/10/24.
//

import Foundation

struct PhotoModel: Codable {
    let id: String
    let created_at: String
    let updated_at: String?
    let promoted_at: String?
    let width: Int
    let height: Int
    let color: String
    let blur_hash: String
    let description: String?
    let alt_description: String?
    let urls: [String: String]
//    let links: [String: String]
//    let categories: [String]?
//    let likes: Int
//    let liked_by_user: Bool
//    let current_user_collections: [String]?
//    let sponsorship: SponsorshipModel?
//    let user: UserModel?
}
