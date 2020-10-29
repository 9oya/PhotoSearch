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
    
    func loadPhotosWith() {
        interactor.loadPhotosWith()
    }
    
    func loadPhotosWith(keyword: String) {
        interactor.loadPhotosWith(keyword: keyword)
    }
    
    func numberOfHeaderSections() -> Int {
        return interactor.numberOfHeaderSections()
    }
    
    func numberOfOriginPhotos() -> Int {
        return interactor.numberOfOriginPhotos()
    }
    
    func numberOfSearchResultPhotos() -> Int {
        return interactor.numberOfSearchResultPhotos()
    }
    
    func numberOfDetailPhotos() -> Int {
        return interactor.numberOfDetailPhotos()
    }
    
    func originPhotoAt(indexPath: IndexPath) -> PhotoModel {
        return interactor.originPhotoAt(indexPath: indexPath)
    }
    
    func searchResultPhotoAt(indexPath: IndexPath) -> PhotoModel? {
        return interactor.searchResultPhotoAt(indexPath: indexPath)
    }
    
    func detailPhotoAt(indexPath: IndexPath) -> PhotoModel {
        return interactor.detailPhotoAt(indexPath: indexPath)
    }

    func configureOriginPhotoCollectionCell(cell: PhotoCollectionCell, indexPath: IndexPath) {
        interactor.configureOriginPhotoCollectionCell(cell: cell, indexPath: indexPath)
    }
    
    func configureSearchResultPhotoCollectionCell(cell: PhotoCollectionCell, indexPath: IndexPath) {
        interactor.configureSearchResultPhotoCollectionCell(cell: cell, indexPath: indexPath)
    }
    
    func configureDetailPhotoCollectionCell(cell: PhotoCollectionCell, indexPath: IndexPath) {
        interactor.configureDetailPhotoCollectionCell(cell: cell, indexPath: indexPath)
    }
    
    func getOriginPhotoCellSize(width:CGFloat, indexPath: IndexPath) -> CGSize {
        return interactor.getOriginPhotoCellSize(width: width, indexPath: indexPath)
    }
    
    func getSearchResultPhotoCellSize(width:CGFloat, indexPath: IndexPath) -> CGSize {
        return interactor.getSearchResultPhotoCellSize(width: width, indexPath: indexPath)
    }
    
    func getDetailPhotoCellSize(width: CGFloat, indexPath: IndexPath) -> CGSize {
        return interactor.getDetailPhotoCellSize(width: width, indexPath: indexPath)
    }
    
    func resetSearchResultPhotos() {
        interactor.resetSearchResultPhotos()
    }
    
    // MARK: HomeInteractorOutput
    func reloadOriginPhotoCollectionView() {
        view.reloadOriginPhotoCollectionView()
    }
    
    func reloadSearchResultPhotoCollectionView() {
        view.reloadSearchResultPhotoCollectionView()
    }
    
    func reloadDetailPhotoCollectionView() {
        view.reloadDetailPhotoCollectionView()
    }
}
