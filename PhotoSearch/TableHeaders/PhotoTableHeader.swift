//
//  PhotoTableHeader.swift
//  PhotoSearch
//
//  Created by Eido Goya on 2020/10/24.
//

import UIKit

let photoTableViewHeaderId = "photoTableViewHeaderId"

class PhotoTableHeader: UITableViewHeaderFooterView {
    
//    var searchBar: UISearchBar!
    
    var imageView: UIImageView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoTableHeader {
    private func setupLayout() {
        contentView.backgroundColor = .white
        
        backgroundColor = .white
        
        imageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "vincent-ledvina")
            imgView.contentMode = .scaleAspectFit
            imgView.translatesAutoresizingMaskIntoConstraints = false
            return imgView
        }()
        
        contentView.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
}
