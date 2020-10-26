//
//  HomeHomeInteractorInput.swift
//  PhotoSearch
//
//  Created by 9oya on 24/10/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import Foundation

protocol HomeInteractorInput {
    
    func loadPhotos(keyword: String?, fetchStart: Int, fetchSize: Int)
    
    func numberOfHeaderSections() -> Int
    
    func numberOfPhotos() -> Int
    
    func photoAt(indexPath: IndexPath) -> PhotoModel
    
    func configurePhotoCollectionCell(cell: PhotoCollectionCell)
    
}
