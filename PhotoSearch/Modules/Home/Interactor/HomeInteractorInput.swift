//
//  HomeHomeInteractorInput.swift
//  PhotoSearch
//
//  Created by 9oya on 24/10/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit

protocol HomeInteractorInput {
    
    func loadPhotosWith()
    
    func loadPhotosWith(keyword: String)
    
    func numberOfHeaderSections() -> Int
    
    func numberOfOriginPhotos() -> Int
    
    func numberOfSearchResultPhotos() -> Int
    
    func numberOfDetailPhotos() -> Int
    
    func originPhotoAt(indexPath: IndexPath) -> PhotoModel
    
    func searchResultPhotoAt(indexPath: IndexPath) -> PhotoModel?
    
    func detailPhotoAt(indexPath: IndexPath) -> PhotoModel
    
    func configureOriginPhotoCollectionCell(cell: PhotoCollectionCell, indexPath: IndexPath)
    
    func configureSearchResultPhotoCollectionCell(cell: PhotoCollectionCell, indexPath: IndexPath)
    
    func configureDetailPhotoCollectionCell(cell: PhotoCollectionCell, indexPath: IndexPath)
    
    func getOriginPhotoCellSize(width:CGFloat, indexPath: IndexPath) -> CGSize
    
    func getSearchResultPhotoCellSize(width:CGFloat, indexPath: IndexPath) -> CGSize
    
    func getDetailPhotoCellSize(width:CGFloat, indexPath: IndexPath) -> CGSize
    
    func resetSearchResultPhotos()
    
}
