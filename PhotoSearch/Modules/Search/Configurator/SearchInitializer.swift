//
//  SearchSearchInitializer.swift
//  PhotoSearch
//
//  Created by 9oya on 24/10/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit

class SearchModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var searchViewController: SearchViewController!

    override func awakeFromNib() {

        let configurator = SearchModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: searchViewController)
    }

}
