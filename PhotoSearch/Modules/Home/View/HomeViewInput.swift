//
//  HomeHomeViewInput.swift
//  PhotoSearch
//
//  Created by 9oya on 24/10/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

protocol HomeViewInput: class {

    /**
        @author 9oya
        Setup initial state of the view
    */

    func setupInitialState()
    
    func reloadPhotoCollectionView()
}
