//
//  DetailDetailPresenter.swift
//  PhotoSearch
//
//  Created by 9oya on 24/10/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

class DetailPresenter: DetailModuleInput, DetailViewOutput, DetailInteractorOutput {

    weak var view: DetailViewInput!
    var interactor: DetailInteractorInput!
    var router: DetailRouterInput!

    func viewIsReady() {

    }
}
