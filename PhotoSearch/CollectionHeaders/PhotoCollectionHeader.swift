//
//  PhotoCollectionHeader.swift
//  PhotoSearch
//
//  Created by Eido Goya on 2020/10/24.
//

import UIKit

let photoCollectionHeaderId = "photoCollectionHeaderId"

class PhotoCollectionHeader: UICollectionReusableView {
    
    var searchBar: UISearchBar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoCollectionHeader {
    private func setupLayout() {
        backgroundColor = .white
        
        searchBar = {
            let searchBar = UISearchBar()
            return searchBar
        }()
        
        addSubview(searchBar)
        
        
    }
}
