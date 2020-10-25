//
//  HomeHomeViewController.swift
//  PhotoSearch
//
//  Created by 9oya on 24/10/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, HomeViewInput {
    
    // MARK: Properties
    var photoCollectionView: UICollectionView!
    
    var photoTableView: UITableView!
    
    var searchBar: UISearchBar!
    
    var headerTitleLabel: UILabel!
    
    let searchBarHeight: CGFloat = 74
    
    var output: HomeViewOutput!
    let configurator = HomeModuleConfigurator()
    
    var setBackgroundColor: ((UIColor, CGFloat) -> Void)? = nil

    // MARK: Life cycle
    override func loadView() {
        super.loadView()
        
        // DI
        configurator.configureModuleForViewInput(viewInput: self)
        
        // Load views
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: Actions
    func toggleSearchBarLayout() {
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            if searchBar.isTranslucent {
                searchTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
                searchTextField.textColor = .white
                searchTextField.attributedPlaceholder = NSAttributedString(string: "Search photos", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
                
                let glassIconView = searchTextField.leftView as? UIImageView
                glassIconView!.image = glassIconView!.image?.withRenderingMode(.alwaysTemplate)
                glassIconView!.tintColor = .white
            } else {
                searchTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                searchTextField.textColor = .black
                searchTextField.attributedPlaceholder = NSAttributedString(string: "Search photos", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
                
                let glassIconView = searchTextField.leftView as? UIImageView
                glassIconView!.image = glassIconView!.image?.withRenderingMode(.alwaysTemplate)
                glassIconView!.tintColor = .gray
            }
        }
    }
    
    // MARK: HomeViewInput
    func setupInitialState() {
        output.loadPhotos(keyword: nil, fetchStart: 0, fetchSize: 10)
    }
    
    func reloadPhotoTableView() {
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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: photoCollectionHeaderId, for: indexPath) as!PhotoCollectionHeader
        setBackgroundColor = headerView.setBackgroundColor
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCollectionCellId, for: indexPath) as! PhotoCollectionCell
        output.configurePhotoCollectionCell(cell: cell)
        return cell
    }

    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 2.4)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 500)
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 1;
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1;
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffSetY = scrollView.contentOffset.y
        print(contentOffSetY)
        
        if !searchBar.isTranslucent {
            return
        }

        if contentOffSetY > 100 {
            searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: searchBarHeight)
            return
        }
        
        setBackgroundColor?(UIColor.white, (contentOffSetY * 0.01) - 0.1)
        searchBar.backgroundColor = UIColor.white.withAlphaComponent((contentOffSetY * 0.01) - 0.2)
        
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
            searchTextField.textColor = .white
            searchTextField.attributedPlaceholder = NSAttributedString(string: "Search photos", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            
            let glassIconView = searchTextField.leftView as? UIImageView
            glassIconView!.image = glassIconView!.image?.withRenderingMode(.alwaysTemplate)
            glassIconView!.tintColor = .white
        }
        
        searchBar.frame = CGRect(x: 0, y: 100 - contentOffSetY, width: view.frame.width, height: searchBarHeight)
    }
}

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        
    }

    // MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2) {
            self.photoCollectionView.contentOffset.y = 100
        }
        searchBar.isTranslucent = false
        searchBar.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        toggleSearchBarLayout()
        
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.isTranslucent = true
        toggleSearchBarLayout()
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        
        UIView.animate(withDuration: 0.2) {
            if self.photoCollectionView.contentOffset.y == 0 {
                self.searchBar.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.searchBarHeight)
                self.searchBar.backgroundColor = .clear
                self.setBackgroundColor?(UIColor.white, 0)
            } else {
                self.photoCollectionView.contentOffset.y = 0
            }
        }
    }
}

extension HomeViewController {
    
    // MARK: Load views
    private func setupLayout() {
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .clear
        
        photoCollectionView = {
            let layout = PhotoCollectionFlowLayout()
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.backgroundColor = .blue
            collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: photoCollectionCellId)
            collectionView.register(PhotoCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: photoCollectionHeaderId)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
        
        headerTitleLabel = {
            let lable = UILabel()
            lable.text = "Photos for everyone"
            lable.textColor = .white
            lable.font = .systemFont(ofSize: 25, weight: .bold)
            lable.translatesAutoresizingMaskIntoConstraints = false
            return lable
        }()
        
        searchBar = {
            let searchBar = UISearchBar(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: searchBarHeight))
            searchBar.isTranslucent = true
            searchBar.tintColor = .darkGray
            searchBar.backgroundImage = UIImage()
            return searchBar
        }()
        
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.borderStyle = .roundedRect
            searchTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
            searchTextField.textColor = .white
            searchTextField.attributedPlaceholder = NSAttributedString(string: "Search photos", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            
            let glassIconView = searchTextField.leftView as? UIImageView
            glassIconView!.image = glassIconView!.image?.withRenderingMode(.alwaysTemplate)
            glassIconView!.tintColor = .white
        }
        
        let cancelButtonAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        
        view.addSubview(photoCollectionView)
        view.addSubview(headerTitleLabel)
        view.addSubview(searchBar)
        
        searchBar.delegate = self
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self

        photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20).isActive = true
        photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        headerTitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        headerTitleLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: 5).isActive = true
    }
}
