//
//  PhotoCollectionFlowLayout.swift
//  PhotoSearch
//
//  Created by Eido Goya on 2020/10/24.
//

import UIKit

class PhotoCollectionFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach({ (attributes) in
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                guard let collectionView = collectionView else { return }
                if collectionView.contentOffset.y > 0 {
                    return
                }
                
                // header
                attributes.frame = CGRect(x: 0,
                                          y: collectionView.contentOffset.y,
                                          width: collectionView.frame.width,
                                          height: attributes.frame.height - collectionView.contentOffset.y)
            }
        })
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
