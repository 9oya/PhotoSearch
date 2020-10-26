//
//  SponsorshipModel.swift
//  PhotoSearch
//
//  Created by Eido Goya on 2020/10/27.
//

import Foundation

struct SponsorshipModel: Codable {
    let impression_urls: [String]?
    let tagline: String?
    let tagline_url: String?
    let sponsor: UserModel
}
