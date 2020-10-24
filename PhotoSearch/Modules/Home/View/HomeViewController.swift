//
//  HomeHomeViewController.swift
//  PhotoSearch
//
//  Created by 9oya on 24/10/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, HomeViewInput {
    
    var photoCollectionView: UICollectionView!

    var output: HomeViewOutput!
    let configurator = HomeModuleConfigurator()

    // MARK: Life cycle
    override func loadView() {
        // DI
        configurator.configureModuleForViewInput(viewInput: self)
        
        // Load views
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    // MARK: HomeViewInput
    func setupInitialState() {
        
    }
    
    func reloadCollectionView() {
        photoCollectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return output.numberOfHeaderSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return output.numberOfPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: phtoCollectionCellId, for: indexPath) as! PhotoCollectionCell
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 2.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1;
    }
}

extension HomeViewController {
    // MARK: Load views
    private func setupLayout() {
        
        photoCollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: phtoCollectionCellId)
            collectionView.register(PhotoCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: photoCollectionHeaderId)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
        
        view.addSubview(photoCollectionView)
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
    }
}
