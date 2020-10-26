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
    
    // MARK: HomeInteractorInput
    func loadPhotos(keyword: String?, fetchStart: Int, fetchSize: Int) {
        var dataTask: URLSessionDataTask?
        dataTask = URLSession(configuration: .default).dataTask(with: APIRouter.getPhotos(clientId: "LkoRkbGfqK7_iN5XFWuWqT1VP71I8BTnNvt5egvBbpM", page: 1).asURLRequest(), completionHandler: { (data, response, error) in
            defer {
                dataTask = nil
            }
            if error != nil {
                print(error.debugDescription)
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    do {
                        let decodedData = try JSONDecoder().decode([PhotoModel].self, from: data)
                        self.getPhotos = {
                            return decodedData
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
        return 10
    }
    
    func configurePhotoCollectionCell(cell: PhotoCollectionCell) {
        
    }
    
}
