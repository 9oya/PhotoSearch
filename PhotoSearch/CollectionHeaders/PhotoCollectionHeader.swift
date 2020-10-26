//
//  PhotoCollectionHeader.swift
//  PhotoSearch
//
//  Created by Eido Goya on 2020/10/24.
//

import UIKit

let photoCollectionHeaderId = "photoCollectionHeaderId"

class PhotoCollectionHeader: UICollectionReusableView {
    
    var imageView: UIImageView!
    var staticBackgroundColorView: UIView!
    var dynamicBackgrounColorView: UIView!
    
    var animator: UIViewPropertyAnimator!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackgroundColor(color: UIColor, alphcomponent: CGFloat) {
        dynamicBackgrounColorView.backgroundColor = color.withAlphaComponent(alphcomponent)
    }
    
    func hideHeaderInnerBGBlind() {
        dynamicBackgrounColorView.isHidden = true
    }
    
    func showHeaderInnerBGBlind() {
        dynamicBackgrounColorView.isHidden = false
    }
}

extension PhotoCollectionHeader {
    private func setupLayout() {
        
        backgroundColor = .white
        
        staticBackgroundColorView = {
            let view = UIView(frame: CGRect(x: 0, y: frame.height / 2, width: frame.width, height: 100))
            view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        dynamicBackgrounColorView = {
            let view = UIView(frame: CGRect(x: 0, y: frame.height / 2, width: frame.width, height: 100))
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        imageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "vincent-ledvina")
            imgView.contentMode = .scaleAspectFill
            imgView.translatesAutoresizingMaskIntoConstraints = false
            return imgView
        }()
        
        addSubview(imageView)
        addSubview(staticBackgroundColorView)
        addSubview(dynamicBackgrounColorView)
        
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        staticBackgroundColorView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        staticBackgroundColorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        staticBackgroundColorView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        staticBackgroundColorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        dynamicBackgrounColorView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        dynamicBackgrounColorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        dynamicBackgrounColorView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        dynamicBackgrounColorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
}
