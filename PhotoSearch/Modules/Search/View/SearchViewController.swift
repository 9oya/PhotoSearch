//
//  SearchSearchViewController.swift
//  PhotoSearch
//
//  Created by 9oya on 24/10/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, SearchViewInput {

    var output: SearchViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: SearchViewInput
    func setupInitialState() {
    }
}
