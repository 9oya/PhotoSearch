//
//  SearchResultPhotoCollectionHeader.swift
//  PhotoSearch
//
//  Created by Eido Goya on 2020/10/29.
//

import UIKit

let searchResultPhotoCollectionHeaderId = "searchResultPhotoCollectionHeaderId"

class SearchResultPhotoCollectionHeader: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setuplayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultPhotoCollectionHeader {
    private func setuplayout() {
        backgroundColor = .white
    }
}
