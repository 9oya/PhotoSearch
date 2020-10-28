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
    
    var getPhotos: (() -> [PhotoModel])?
    
    var getNextPageOfPhotos: (() -> Int) = {
        return 1
    }
    
    // MARK: HomeInteractorInput
    func loadPhotos(keyword: String?, fetchStart: Int, fetchSize: Int) {
        let page = getNextPageOfPhotos()
        var dataTask: URLSessionDataTask?
        dataTask = URLSession(configuration: .default).dataTask(with: APIRouter.getPhotos(clientId: "LkoRkbGfqK7_iN5XFWuWqT1VP71I8BTnNvt5egvBbpM", page: page).asURLRequest(), completionHandler: { (data, response, error) in
            defer {
                dataTask = nil
            }
            if error != nil {
                print(error.debugDescription)
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    do {
                        let newPhotos = try JSONDecoder().decode([PhotoModel].self, from: data)
                        let currPage = self.getNextPageOfPhotos()
                        let prevPhotos = self.getPhotos?()
                        self.getPhotos = {
                            return prevPhotos != nil ? prevPhotos! + newPhotos : newPhotos
                        }
                        self.getNextPageOfPhotos = {
                            return currPage + 1
                        }
                        DispatchQueue.main.async {
                            self.output.reloadCollectionView()
                        }
                    } catch let error {
                        print(error.localizedDescription)
                        return
                    }
                }
            }
        })
        
        dataTask?.resume()
    }
    
    func photoAt(indexPath: IndexPath) -> PhotoModel {
        return getPhotos!()[indexPath.item]
    }
    
    func numberOfHeaderSections() -> Int {
        return 1
    }
    
    func numberOfPhotos() -> Int {
        return getPhotos != nil ? getPhotos!().count : 0
    }
    
    func configurePhotoCollectionCell(cell: PhotoCollectionCell, indexPath: IndexPath) {
        let photo = photoAt(indexPath: indexPath)
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
    
    func getCellSize(width:CGFloat, indexPath: IndexPath) -> CGSize {
        let photo = photoAt(indexPath: indexPath)
        
        let ratio: CGFloat = width / CGFloat(photo.width)
        
        return CGSize(width: width, height: CGFloat(photo.height) * ratio)
    }
    
}
