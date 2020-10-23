//
//  DetailDetailConfigurator.swift
//  PhotoSearch
//
//  Created by 9oya on 24/10/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit

class DetailModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? DetailViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: DetailViewController) {

        let router = DetailRouter()

        let presenter = DetailPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = DetailInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
