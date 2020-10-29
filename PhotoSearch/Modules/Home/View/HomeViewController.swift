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
    var searchBar: UISearchBar!
    var originPhotoCollectionView: UICollectionView!
    var searchResultPhotoCollectionView: UICollectionView!
    var horizontalPhotoCollectionView: UICollectionView!
    var headerOuterBGBlindView: UIView!
    var originPhotoCollectionBlindView: UIView!
    var headerTitleLabel: UILabel!
    var headerOuterBGBlindHeightConstraint: NSLayoutConstraint!
    
    let searchBarHeight: CGFloat = 74
    var headerHeight: CGFloat!
    var initialYForSearchBar: CGFloat!
    var lastContentOffsetYOfOrigin: CGFloat = 0.0
    var lastContentOffsetYOfSearchResult: CGFloat = 0.0
    var isScrollToLoading: Bool = false
    var searchKeyword: String?
    
    var setHeaderInnerBGBlindColor: ((UIColor, CGFloat) -> Void)! = nil
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
        output.loadPhotosWith()
    }
    
    func reloadOriginPhotoCollectionView() {
        originPhotoCollectionView.reloadData()
        isScrollToLoading = false
    }
    
    func reloadSearchResultPhotoCollectionView() {
        searchResultPhotoCollectionView.reloadData()
        isScrollToLoading = false
        originPhotoCollectionView.isHidden = true
        searchResultPhotoCollectionView.isHidden = false
        view.endEditing(true)
    }
    
    func reloadHorizontalPhotoCollectionView() {
        horizontalPhotoCollectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return output.numberOfHeaderSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var numberOfItems = 0
        if collectionView == originPhotoCollectionView {
            numberOfItems = output.numberOfOriginPhotos()
        } else {
            numberOfItems = output.numberOfSearchResultPhotos()
        }
        
        return numberOfItems
        
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == originPhotoCollectionView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: originPhotoCollectionHeaderId, for: indexPath) as! OriginPhotoCollectionHeader
            setHeaderInnerBGBlindColor = headerView.setBackgroundColor(color:alphcomponent:)
            hideHeaderInnerBGBlind = headerView.hideHeaderInnerBGBlind
            showHeaderInnerBGBlind = headerView.showHeaderInnerBGBlind
            return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: searchResultPhotoCollectionHeaderId, for: indexPath) as! SearchResultPhotoCollectionHeader
            return headerView
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCollectionCellId, for: indexPath) as! PhotoCollectionCell
        if collectionView == originPhotoCollectionView {
            output.configureOriginPhotoCollectionCell(cell: cell, indexPath: indexPath)
        } else {
            output.configureSearchResultPhotoCollectionCell(cell: cell, indexPath: indexPath)
        }
        
        return cell
        
    }

    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var headerSize = CGSize(width: 0, height: 0)
        if collectionView == originPhotoCollectionView {
            headerSize = CGSize(width: view.frame.width, height: headerHeight)
        } else if collectionView == searchResultPhotoCollectionView {
            if view.frame.height <= 568 {
                // SE
                headerSize = CGSize(width: view.frame.width, height: searchBarHeight)
            } else if view.frame.height <= 667 {
                // 6, 7, 8
                headerSize = CGSize(width: view.frame.width, height: searchBarHeight + 20)
            } else if view.frame.height >= 812 {
                // 11, 11Pro, 11ProMax
                headerSize = CGSize(width: view.frame.width, height: searchBarHeight + 50)
            }
        }
        
        return headerSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == originPhotoCollectionView {
            return output.getOriginPhotoCellSize(width: view.frame.width, indexPath: indexPath)
        } else {
            return output.getSearchResultPhotoCellSize(width: view.frame.width, indexPath: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1;
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = scrollView.contentOffset.y
        print("ContentOffSetY: \(contentOffsetY)")
        print("Frame Height: \(view.frame.height)")
//        print("Header Height: \(headerHeight!)")
//        print("InitialYForSearchBar: \(initialYForSearchBar!)")
        print("CollectionOffSetY: \(originPhotoCollectionView.contentOffset.y)")
        
        if !searchResultPhotoCollectionView.isHidden {
            if (scrollView.frame.size.height + contentOffsetY) > (scrollView.contentSize.height - 500) {
                if lastContentOffsetYOfSearchResult > contentOffsetY {
                    // Case scrolled up
                    return
                }
                lastContentOffsetYOfSearchResult = contentOffsetY
                if isScrollToLoading {
                    return
                }
                isScrollToLoading = true
                if searchKeyword != nil {
                    output.loadPhotosWith(keyword: searchKeyword!)
                }
            }
        } else {
            if (scrollView.frame.size.height + contentOffsetY) > (scrollView.contentSize.height - 500) {
                if lastContentOffsetYOfOrigin > contentOffsetY {
                    // Case scrolled up
                    return
                }
                lastContentOffsetYOfOrigin = contentOffsetY
                if isScrollToLoading {
                    return
                }
                isScrollToLoading = true
                output.loadPhotosWith()
            }
        }
        
        if !searchBar.isTranslucent {
            // Stop changing layout when searchBar is activating...
            return
        }
        
        // Start changing layout
        if view.frame.height <= 568 {
            // SE
            if contentOffsetY > initialYForSearchBar {
                searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: searchBarHeight)
                headerOuterBGBlindHeightConstraint.constant = headerHeight - contentOffsetY
                hideHeaderTitleLabel()

                // Swap header background blind views
                if contentOffsetY > 160 {
                    hideHeaderInnerBGBlind()
                    headerOuterBGBlindView.isHidden = false
                    headerOuterBGBlindHeightConstraint.constant = searchBarHeight
                } else {
                    showHeaderInnerBGBlind()
                    headerOuterBGBlindView.isHidden = true
                }
                return
            }
        } else if view.frame.height <= 667 {
            // 6, 7, 8
            if contentOffsetY > initialYForSearchBar {
                searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: searchBarHeight)
                headerOuterBGBlindHeightConstraint.constant = headerHeight - contentOffsetY
                hideHeaderTitleLabel()

                // Swap header background blind views
                if contentOffsetY > 184 {
                    hideHeaderInnerBGBlind()
                    headerOuterBGBlindView.isHidden = false
                    headerOuterBGBlindHeightConstraint.constant = searchBarHeight + 20
                } else {
                    showHeaderInnerBGBlind()
                    headerOuterBGBlindView.isHidden = true
                }
                return
            }
        } else if view.frame.height >= 812 {
            // 11, 11Pro, 11ProMax
            if contentOffsetY >= 134 {
                searchBar.frame = CGRect(x: 0, y: (view.frame.height * 0.15) - 80, width: view.frame.width, height: searchBarHeight)
                headerOuterBGBlindHeightConstraint.constant = headerHeight - contentOffsetY
                hideHeaderTitleLabel()
                
                // Swap header background blind views
                if contentOffsetY > 223 {
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
        let alphaComp = ((contentOffsetY * 0.01) - 0.3) < 0.9 ? ((contentOffsetY * 0.01) - 0.3) : 0.9
        setHeaderInnerBGBlindColor(UIColor.white, alphaComp)
        headerOuterBGBlindView.backgroundColor = UIColor.white.withAlphaComponent(0.99)
        headerOuterBGBlindHeightConstraint.constant = headerHeight - contentOffsetY
        showHeaderTitleLabel()
        
        // Change searchBar's Y offset
        searchBar.frame = CGRect(x: 0, y: initialYForSearchBar - contentOffsetY, width: view.frame.width, height: searchBarHeight)
    }
}

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        
    }

    // MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        originPhotoCollectionBlindView.isHidden = false
        lastContentOffsetYOfOrigin = self.originPhotoCollectionView.contentOffset.y
        
        if self.originPhotoCollectionView.contentOffset.y < initialYForSearchBar {
            if self.view.frame.height <= 568 {
                // SE
                self.originPhotoCollectionView.contentOffset.y = 160
            } else if self.view.frame.height <= 667 {
                // 6, 7, 8
                self.originPhotoCollectionView.contentOffset.y = 184
            } else if self.view.frame.height >= 812 {
                // 11, 11Pro, 11ProMax
                self.originPhotoCollectionView.contentOffset.y = 223
                headerOuterBGBlindView.backgroundColor = UIColor.white.withAlphaComponent(0.99)
                self.headerOuterBGBlindView.isHidden = false
            }
        }
        
        hideHeaderTitleLabel()
        searchBar.isTranslucent = false
        toggleSearchBarLayout()
        searchBar.showsCancelButton = true
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        originPhotoCollectionBlindView.isHidden = true
        searchResultPhotoCollectionView.isHidden = true
        searchResultPhotoCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        originPhotoCollectionView.isHidden = false
        searchBar.text = ""
        
        searchBar.isTranslucent = true
        toggleSearchBarLayout()
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        
        UIView.animate(withDuration: 0.2) {
            if self.lastContentOffsetYOfOrigin == 0.0 {
                self.searchBar.frame = CGRect(x: 0, y: self.initialYForSearchBar, width: self.view.frame.width, height: self.searchBarHeight)
            }
            if self.view.frame.height <= 568 {
                // SE
                if self.originPhotoCollectionView.contentOffset.y <= 160 {
                    self.originPhotoCollectionView.contentOffset.y = self.lastContentOffsetYOfOrigin
                }
            } else if self.view.frame.height <= 667 {
                // 6, 7, 8
                if self.originPhotoCollectionView.contentOffset.y <= 184 {
                    self.originPhotoCollectionView.contentOffset.y = self.lastContentOffsetYOfOrigin
                }
            } else if self.view.frame.height >= 812 {
                // 11, 11Pro, 11ProMax
                if self.originPhotoCollectionView.contentOffset.y <= 223 {
                    self.originPhotoCollectionView.contentOffset.y = self.lastContentOffsetYOfOrigin
                    self.headerOuterBGBlindView.isHidden = true
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !(searchBar.text == searchKeyword) {
            output.resetSearchResultPhotos()
        }
        
        if searchBar.text != nil || searchBar.text?.count ?? 0 > 0 || searchBar.text != "" {
            searchKeyword = searchBar.text!
            output.loadPhotosWith(keyword: searchKeyword!)
        }
        
    }
}

extension HomeViewController {
    
    private func getPhotoCollectionView() -> UICollectionView {
        let layout = PhotoCollectionFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: photoCollectionCellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    // MARK: Load views
    private func setupLayout() {
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .clear
        
        headerHeight = view.frame.height / 2.4
        initialYForSearchBar = headerHeight / 2
        
        originPhotoCollectionView = getPhotoCollectionView()
        originPhotoCollectionView.register(OriginPhotoCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: originPhotoCollectionHeaderId)
        
        searchResultPhotoCollectionView = getPhotoCollectionView()
        searchResultPhotoCollectionView.register(SearchResultPhotoCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: searchResultPhotoCollectionHeaderId)
        searchResultPhotoCollectionView.isHidden = true
        
        headerTitleLabel = {
            let lable = UILabel()
            lable.text = "Photos for everyone"
            lable.textColor = .white
            lable.font = .systemFont(ofSize: 25, weight: .bold)
            lable.translatesAutoresizingMaskIntoConstraints = false
            return lable
        }()
        headerOuterBGBlindView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        originPhotoCollectionBlindView = {
            let view = UIView()
            view.backgroundColor = UIColor.white
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        searchBar = {
            let searchBar = UISearchBar(frame: CGRect(x: 0, y: initialYForSearchBar, width: view.frame.width, height: searchBarHeight))
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
        
        view.addSubview(originPhotoCollectionView)
        view.addSubview(originPhotoCollectionBlindView)
        view.addSubview(searchResultPhotoCollectionView)
        view.addSubview(headerOuterBGBlindView)
        view.addSubview(headerTitleLabel)
        view.addSubview(searchBar)
        
        searchBar.delegate = self
        originPhotoCollectionView.delegate = self
        originPhotoCollectionView.dataSource = self
        searchResultPhotoCollectionView.delegate = self
        searchResultPhotoCollectionView.dataSource = self

        originPhotoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -(view.frame.height * 0.06)).isActive = true
        originPhotoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        originPhotoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        originPhotoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: view.frame.height * 0.06).isActive = true
        
        searchResultPhotoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -(view.frame.height * 0.06)).isActive = true
        searchResultPhotoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        searchResultPhotoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        searchResultPhotoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: view.frame.height * 0.06).isActive = true
        
        headerOuterBGBlindView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -(view.frame.height * 0.06)).isActive = true
        headerOuterBGBlindView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        headerOuterBGBlindView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        headerOuterBGBlindHeightConstraint = headerOuterBGBlindView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.4)
        headerOuterBGBlindHeightConstraint.priority = UILayoutPriority(999)
        headerOuterBGBlindHeightConstraint.isActive = true
        
        originPhotoCollectionBlindView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -(view.frame.height * 0.06)).isActive = true
        originPhotoCollectionBlindView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        originPhotoCollectionBlindView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        originPhotoCollectionBlindView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: view.frame.height * 0.06).isActive = true
        
        headerTitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        headerTitleLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: 5).isActive = true
    }
}
