//
//  HomeHomeViewController.swift
//  PhotoSearch
//
//  Created by 9oya on 24/10/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, HomeViewInput {

    var output: HomeViewOutput!
    let configurator = HomeModuleConfigurator()

    // MARK: Life cycle
    override func loadView() {
        configurator.configureModuleForViewInput(viewInput: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: HomeViewInput
    func setupInitialState() {
        setupLayout()
    }
}

extension HomeViewController {
    private func setupLayout() {
        
    }
}
