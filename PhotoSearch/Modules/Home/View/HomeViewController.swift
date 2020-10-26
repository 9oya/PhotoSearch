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
    var headerOuterBGBlindView: UIView!
    var headerTitleLabel: UILabel!
    var headerOuterBGBlindHeightConstraint: NSLayoutConstraint!
    
    let searchBarHeight: CGFloat = 74
    var headerHeight: CGFloat!
    var initialYForSearchBar: CGFloat!
    var lastCollectionContentOffset: CGFloat = 0.0
    
    var setBackgroundColor: ((UIColor, CGFloat) -> Void)! = nil
    var hideHeaderInnerBGBlind: (() -> (Void))! = nil
    var showHeaderInnerBGBlind: (() -> (Void))! = nil
    
    var output: HomeViewOutput!
    let configurator = HomeModuleConfigurator()
    
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
        if searchBar.isTranslucent {
            changeSearchBarLayoutToTranslucentState()
        } else {
            changeSearchBarLayoutToOpaqueState()
        }
    }
    
    func changeSearchBarLayoutToTranslucentState() {
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
            searchTextField.textColor = .white
            searchTextField.attributedPlaceholder = NSAttributedString(string: "Search photos", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            
            let glassIconView = searchTextField.leftView as? UIImageView
            glassIconView!.image = glassIconView!.image?.withRenderingMode(.alwaysTemplate)
            glassIconView!.tintColor = .white
        }
    }
    
    func changeSearchBarLayoutToOpaqueState() {
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            searchTextField.textColor = .black
            searchTextField.attributedPlaceholder = NSAttributedString(string: "Search photos", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
            
            let glassIconView = searchTextField.leftView as? UIImageView
            glassIconView!.image = glassIconView!.image?.withRenderingMode(.alwaysTemplate)
            glassIconView!.tintColor = .gray
        }
    }
    
    func hideHeaderTitleLabel() {
        UIView.transition(with: headerTitleLabel, duration: 0.5, options: .transitionCrossDissolve) {
            self.headerTitleLabel.isHidden = true
        }
    }
    
    func showHeaderTitleLabel() {
        UIView.transition(with: headerTitleLabel, duration: 0.5, options: .transitionCrossDissolve) {
            self.headerTitleLabel.isHidden = false
        }
    }
    
    // MARK: HomeViewInput
    func setupInitialState() {
        output.loadPhotos(keyword: nil, fetchStart: 0, fetchSize: 10)
    }
    
    func reloadPhotoCollectionView() {
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
        setBackgroundColor = headerView.setBackgroundColor(color:alphcomponent:)
        hideHeaderInnerBGBlind = headerView.hideHeaderInnerBGBlind
        showHeaderInnerBGBlind = headerView.showHeaderInnerBGBlind
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCollectionCellId, for: indexPath) as! PhotoCollectionCell
        output.configurePhotoCollectionCell(cell: cell)
        cell.backgroundColor = .green
        return cell
    }

    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: headerHeight)
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
        print("ContentOffSetY: \(contentOffSetY)")
//        print("Frame Height: \(view.frame.height)")
//        print("Header Height: \(headerHeight!)")
//        print("InitialYForSearchBar: \(initialYForSearchBar!)")
        
        
        if !searchBar.isTranslucent {
            // Stop changing layout
            return
        }
        
        // Start changing layout
        if view.frame.height <= 667 {
            // SE, 6, 7, 8
            if contentOffSetY > initialYForSearchBar {
                searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: searchBarHeight)
                headerOuterBGBlindHeightConstraint.constant = headerHeight - contentOffSetY
                hideHeaderTitleLabel()

                // Swap header background blind views
                if contentOffSetY > 160 {
                    hideHeaderInnerBGBlind()
                    headerOuterBGBlindView.isHidden = false
                    headerOuterBGBlindHeightConstraint.constant = searchBarHeight
                } else {
                    showHeaderInnerBGBlind()
                    headerOuterBGBlindView.isHidden = true
                }
                return
            }
        } else if view.frame.height >= 812 {
            // 11, 11Pro, 11ProMax
            if contentOffSetY >= 134 {
                searchBar.frame = CGRect(x: 0, y: (view.frame.height * 0.15) - 80, width: view.frame.width, height: searchBarHeight)
                headerOuterBGBlindHeightConstraint.constant = headerHeight - contentOffSetY
                hideHeaderTitleLabel()
                
                // Swap header background blind views
                if contentOffSetY > 223 {
                    hideHeaderInnerBGBlind()
                    headerOuterBGBlindView.isHidden = false
                    headerOuterBGBlindHeightConstraint.constant = searchBarHeight + searchBar.frame.origin.y
                } else {
                    showHeaderInnerBGBlind()
                    headerOuterBGBlindView.isHidden = true
                }
                return
            }
        }
        
        // Change header background view state
        let alphaComp = ((contentOffSetY * 0.01) - 0.3) < 0.7 ? ((contentOffSetY * 0.01) - 0.3) : 0.7
        setBackgroundColor(UIColor.white, alphaComp)
        headerOuterBGBlindView.backgroundColor = UIColor.white.withAlphaComponent(alphaComp)
        headerOuterBGBlindHeightConstraint.constant = headerHeight - contentOffSetY
        showHeaderTitleLabel()
        
        // Change searchBar's Y offset
        searchBar.frame = CGRect(x: 0, y: initialYForSearchBar - contentOffSetY, width: view.frame.width, height: searchBarHeight)
    }
}

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        
    }

    // MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.lastCollectionContentOffset = self.photoCollectionView.contentOffset.y
        
        if self.photoCollectionView.contentOffset.y < initialYForSearchBar {
            self.photoCollectionView.contentOffset.y = view.frame.height * 0.15
        }
        
        hideHeaderTitleLabel()
        searchBar.isTranslucent = false
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
            if self.lastCollectionContentOffset == 0.0 {
                self.searchBar.frame = CGRect(x: 0, y: self.initialYForSearchBar, width: self.view.frame.width, height: self.searchBarHeight)
            }
            
            if self.photoCollectionView.contentOffset.y < 160 {
                self.photoCollectionView.contentOffset.y = self.lastCollectionContentOffset
            }
        }
    }
}

extension HomeViewController {
    
    // MARK: Load views
    private func setupLayout() {
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .clear
        
        headerHeight = view.frame.height / 2.4
        initialYForSearchBar = headerHeight / 2
        
        photoCollectionView = {
            let layout = PhotoCollectionFlowLayout()
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.backgroundColor = .white
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
            let searchBar = UISearchBar(frame: CGRect(x: 0, y: initialYForSearchBar, width: view.frame.width, height: searchBarHeight))
            searchBar.isTranslucent = true
            searchBar.tintColor = .darkGray
            searchBar.backgroundImage = UIImage()
            return searchBar
        }()
        headerOuterBGBlindView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
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
        view.addSubview(headerOuterBGBlindView)
        view.addSubview(headerTitleLabel)
        view.addSubview(searchBar)
        
        searchBar.delegate = self
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self

        photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -(view.frame.height * 0.06)).isActive = true
        photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        headerOuterBGBlindView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -(view.frame.height * 0.06)).isActive = true
        headerOuterBGBlindView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        headerOuterBGBlindView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        headerOuterBGBlindHeightConstraint = headerOuterBGBlindView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.4)
        headerOuterBGBlindHeightConstraint.priority = UILayoutPriority(999)
        headerOuterBGBlindHeightConstraint.isActive = true
        
        headerTitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        headerTitleLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: 5).isActive = true
    }
}
