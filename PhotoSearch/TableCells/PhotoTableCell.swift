//
//  PhotoTableCell.swift
//  PhotoSearch
//
//  Created by Eido Goya on 2020/10/24.
//

import UIKit

let photoTableViewCellId = "photoTableViewCellId"


class PhotoTableCell: UITableViewCell {
    
    var photoImageView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoTableCell {
    private func setupLayout() {
        backgroundColor = .white
        selectionStyle = .none
        
        photoImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        addSubview(photoImageView)
        
        photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
}
