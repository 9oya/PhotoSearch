//
//  HomeHomePresenter.swift
//  PhotoSearch
//
//  Created by 9oya on 24/10/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

class HomePresenter: HomeModuleInput, HomeViewOutput, HomeInteractorOutput {

    weak var view: HomeViewInput!
    var interactor: HomeInteractorInput!
    var router: HomeRouterInput!

    // MARK: HomeViewOutput
    func viewIsReady() {
        view.setupInitialState()
    }
    
    // MARK: HomeInteractorOutput
}
