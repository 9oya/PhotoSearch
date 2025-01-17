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
    
    private var getOriginPhotos: (() -> [PhotoModel])?
    private var getSearchResultPhotos: (() -> [PhotoModel]?)?
    private var getDetailPhotos: (() -> [PhotoModel])?
    private var getNextPageOfOriginPhotos: (() -> Int) = {
        return 1
    }
    private var getNextPageOfSearchResultPhotos: (() -> Int) = {
        return 1
    }
    
    private func downloadPhotoImage(urlString: String, photo: PhotoModel) {
        DispatchQueue.global(qos: .default).async {
            if let url = URL(string: urlString) {
                do {
                    let data = try Data(contentsOf: url)
                    photo.photo = data
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                print("There is no value at urls[key]: \'small\'")
            }
        }
    }
    
    private func configurePhotoCollectionCell(cell: PhotoCollectionCell, photo: PhotoModel) {
        if let photoData = photo.photo {
            cell.photoImageView.image = UIImage(data: photoData)
        } else {
            DispatchQueue.global(qos: .default).async {
                if let urlString = photo.urls["small"], let url = URL(string: urlString) {
                    do {
                        let data = try Data(contentsOf: url)
                        DispatchQueue.main.async {
                            cell.photoImageView.image = UIImage(data: data)
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                } else {
                    print("There is no value at urls[key]: \'small\'")
                }
            }
        }
    }
    
    private func getPhotoCellSize(photo: PhotoModel, width:CGFloat, indexPath: IndexPath) -> CGSize {
        let ratio: CGFloat = width / CGFloat(photo.width)
        return CGSize(width: width, height: CGFloat(photo.height) * ratio)
    }
    
    private func makeDataTask(request: URLRequest, dataHandler: @escaping (Data) -> Void) {
        var dataTask: URLSessionDataTask?
        dataTask = URLSession(configuration: .default).dataTask(with: request, completionHandler: { (data, response, error) in
            defer {
                dataTask = nil
            }
            if error != nil {
                print(error.debugDescription)
            }
            if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == HTTPStatus.ok.rawValue {
                    dataHandler(data)
                }
            }
        })
        dataTask?.resume()
    }
    
    // MARK: HomeInteractorInput
    func loadPhotosWith() {
        let request = APIRouter.getPhotos(
            clientId: "LkoRkbGfqK7_iN5XFWuWqT1VP71I8BTnNvt5egvBbpM",
            page: getNextPageOfOriginPhotos()
        )
        makeDataTask(request: request.asURLRequest()) { (data) in
            do {
                let newPhotos = try JSONDecoder().decode([PhotoModel].self, from: data)
                newPhotos.forEach { self.downloadPhotoImage(urlString: $0.urls["small"]!, photo: $0) }
                let currPage = self.getNextPageOfOriginPhotos()
                let prevPhotos = self.getOriginPhotos?()
                self.getOriginPhotos = {
                    return prevPhotos != nil ? prevPhotos! + newPhotos : newPhotos
                }
                self.getDetailPhotos = self.getOriginPhotos
                self.getNextPageOfOriginPhotos = {
                    return currPage + 1
                }
                DispatchQueue.main.async {
                    self.output.reloadOriginPhotoCollectionView()
                }
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func loadPhotosWith(keyword: String) {
        let request = APIRouter.searchPhotos(
            clientId: "LkoRkbGfqK7_iN5XFWuWqT1VP71I8BTnNvt5egvBbpM",
            page: getNextPageOfSearchResultPhotos(),
            query: keyword
        )
        makeDataTask(request: request.asURLRequest()) { (data) in
            do {
                let searchPhotoWrapper = try JSONDecoder().decode(SearchPhotoModel.self, from: data)
                let newPhotos = searchPhotoWrapper.results
                if newPhotos != nil { newPhotos!.forEach { self.downloadPhotoImage(urlString: $0.urls["small"]!, photo: $0) } }
                let currPage = self.getNextPageOfSearchResultPhotos()
                let prevPhotos = self.getSearchResultPhotos?()
                self.getSearchResultPhotos = {
                    if newPhotos == nil {
                        return prevPhotos != nil ? prevPhotos! : nil
                    }
                    return (prevPhotos != nil ? prevPhotos! + newPhotos! : newPhotos)!
                }
                let allResultPhotos = self.getSearchResultPhotos!()!
                self.getDetailPhotos = {
                    return allResultPhotos
                }
                self.getNextPageOfSearchResultPhotos = {
                    return currPage + 1
                }
                DispatchQueue.main.async {
                    self.output.reloadSearchResultPhotoCollectionView()
                }
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func originPhotoAt(indexPath: IndexPath) -> PhotoModel {
        return getOriginPhotos!()[indexPath.item]
    }
    
    func searchResultPhotoAt(indexPath: IndexPath) -> PhotoModel? {
        return getSearchResultPhotos?()![indexPath.item]
    }
    
    func detailPhotoAt(indexPath: IndexPath) -> PhotoModel {
        return getDetailPhotos!()[indexPath.item]
    }
    
    func numberOfHeaderSections() -> Int {
        return 1
    }
    
    func numberOfOriginPhotos() -> Int {
        return getOriginPhotos != nil ? getOriginPhotos!().count : 0
    }
    
    func numberOfSearchResultPhotos() -> Int {
        return getSearchResultPhotos != nil ? (getSearchResultPhotos!() != nil ? getSearchResultPhotos!()!.count : 0) : 0
    }
    
    func numberOfDetailPhotos() -> Int {
        return getDetailPhotos != nil ? getDetailPhotos!().count : 0
    }
    
    func configureOriginPhotoCollectionCell(cell: PhotoCollectionCell, indexPath: IndexPath) {
        let photo = originPhotoAt(indexPath: indexPath)
        configurePhotoCollectionCell(cell: cell, photo: photo)
    }
    
    func configureSearchResultPhotoCollectionCell(cell: PhotoCollectionCell, indexPath: IndexPath) {
        let photo = searchResultPhotoAt(indexPath: indexPath)!
        configurePhotoCollectionCell(cell: cell, photo: photo)
    }
    
    func configureDetailPhotoCollectionCell(cell: PhotoCollectionCell, indexPath: IndexPath) {
        let photo = detailPhotoAt(indexPath: indexPath)
        configurePhotoCollectionCell(cell: cell, photo: photo)
    }
    
    func getOriginPhotoCellSize(width:CGFloat, indexPath: IndexPath) -> CGSize {
        let photo = originPhotoAt(indexPath: indexPath)
        return getPhotoCellSize(photo: photo, width: width, indexPath: indexPath)
    }
    
    func getSearchResultPhotoCellSize(width:CGFloat, indexPath: IndexPath) -> CGSize {
        let photo = searchResultPhotoAt(indexPath: indexPath)!
        return getPhotoCellSize(photo: photo, width: width, indexPath: indexPath)
    }
    
    func getDetailPhotoCellSize(width:CGFloat, indexPath: IndexPath) -> CGSize {
        let photo = detailPhotoAt(indexPath: indexPath)
        return getPhotoCellSize(photo: photo, width: width, indexPath: indexPath)
    }
    
    func resetSearchResultPhotos() {
        getSearchResultPhotos = nil
        getNextPageOfSearchResultPhotos = {
            return 1
        }
    }
    
    func swapAndReloadDeatilPhotos() {
        getDetailPhotos = getOriginPhotos
        output.reloadDetailPhotoCollectionView()
    }
    
}
