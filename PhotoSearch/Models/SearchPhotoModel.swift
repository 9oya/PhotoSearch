//
//  SearchPhotoModel.swift
//  PhotoSearch
//
//  Created by Eido Goya on 2020/10/29.
//

import Foundation

struct SearchPhotoModel: Codable {
    let total: Int
    let total_pages: Int
    let results: [PhotoModel]?
}
