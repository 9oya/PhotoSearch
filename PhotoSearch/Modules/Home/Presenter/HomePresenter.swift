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
        return interactor.numberOfHeaderSections()
    }
    
    func numberOfPhotos() -> Int {
        return interactor.numberOfPhotos()
    }
    
    func photoAt(indexPath: IndexPath) -> PhotoModel {
        return interactor.photoAt(indexPath: indexPath)
    }

    func configurePhotoCollectionCell(cell: PhotoCollectionCell, indexPath: IndexPath) {
        interactor.configurePhotoCollectionCell(cell: cell, indexPath: indexPath)
    }
    
    func getCellSize(width:CGFloat, indexPath: IndexPath) -> CGSize {
        return interactor.getCellSize(width: width, indexPath: indexPath)
    }
    
    // MARK: HomeInteractorOutput
    func reloadCollectionView() {
        view.reloadPhotoCollectionView()
    }
}
