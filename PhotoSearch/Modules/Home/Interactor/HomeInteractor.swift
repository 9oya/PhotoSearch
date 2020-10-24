//
//  HomeHomeInteractor.swift
//  PhotoSearch
//
//  Created by 9oya on 24/10/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit

class HomeInteractor: HomeInteractorInput {

    weak var output: HomeInteractorOutput!
    
    // MARK: HomeInteractorInput
    func loadPhotos(keyword: String?, fetchStart: Int, fetchSize: Int) {
        
    }
    
    func photoAt(indexPath: IndexPath) -> PhotoModel {
        return PhotoModel(title: "Hello")
    }
    
    func numberOfHeaderSections() -> Int {
        return 1
    }
    
    func numberOfPhotos() -> Int {
        return 10
    }
    
    func configurePhotoCollectionCell(cell: PhotoCollectionCell) {
        
    }
    
    func configurePhotoTableCell(cell: PhotoTableCell) {
        
    }
    
}
