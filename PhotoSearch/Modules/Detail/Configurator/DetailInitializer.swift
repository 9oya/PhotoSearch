//
//  DetailDetailInitializer.swift
//  PhotoSearch
//
//  Created by 9oya on 24/10/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit

class DetailModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var detailViewController: DetailViewController!

    override func awakeFromNib() {

        let configurator = DetailModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: detailViewController)
    }

}
