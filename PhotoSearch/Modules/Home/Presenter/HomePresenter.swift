//
//  HomeHomePresenter.swift
//  PhotoSearch
//
//  Created by 9oya on 24/10/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit

class HomePresenter: HomeModuleInput, HomeViewOutput, HomeInteractorOutput {

    weak var view: HomeViewInput!
    var interactor: HomeInteractorInput!
    var router: HomeRouterInput!

    // MARK: HomeViewOutput
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func loadPhotos(keyword: String?, fetchStart: Int, fetchSize: Int) {
        interactor.loadPhotos(keyword: keyword, fetchStart: fetchStart, fetchSize: fetchSize)
    }
    
    func numberOfHeaderSections() -> Int {
        return interactor.numberOfPhotos()
    }
    
    func numberOfPhotos() -> Int {
        return interactor.numberOfPhotos()
    }
    
    func photoAt(indexPath: IndexPath) -> PhotoModel {
        return interactor.photoAt(indexPath: indexPath)
    }
    
    func configurePhotoCollectionCell(cell: PhotoCollectionCell) {
        interactor.configurePhotoCollectionCell(cell: cell)
    }
    
    func configurePhotoTableCell(cell: PhotoTableCell) {
        interactor.configurePhotoTableCell(cell: cell)
    }
    
    // MARK: HomeInteractorOutput
    func reloadCollectionView() {
        view.reloadPhotoTableView()
    }
}
