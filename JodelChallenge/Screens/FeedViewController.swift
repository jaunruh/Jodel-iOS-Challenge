//
//  FeedViewController.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

class FeedViewController : UICollectionViewController {
    
    var data : [[Dictionary<AnyHashable, Any>]] = []
    private let reuseIdentifier = "FeedCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 1
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(FeedViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.addSubview(self.refreshControl)
        
        fetchDataWith(pageNumber: 1, andReplacement: false)
    }
}

// Custom methods
extension FeedViewController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        fetchDataWith(pageNumber: 1, andReplacement: true)
        
        refreshControl.endRefreshing()
    }
    
    func fetchDataWith(pageNumber: Int, andReplacement shouldReplace: Bool) {
        FlickrApi.fetchPhotos(withPageNumber: Int32(pageNumber), andCompletion: { [weak self] (responseArray, error) in
            if shouldReplace {
                self?.data = [responseArray ?? []]
            } else {
                self?.data.append(responseArray ?? [])
            }
            DispatchQueue.main.async(execute: {
                self?.collectionView?.reloadData()
            })
        })
    }
}

// UICollectionViewDataSource methods
extension FeedViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.configure(with: data[indexPath.section][indexPath.row])
        return cell
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    // Set width of single element in collectionview
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // Set insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // Set left inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    // Set section header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader{
            sectionHeader.sectionHeaderLabel.text = "Page \(indexPath.section + 1)"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    // Load new content when at bottom of current feed
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == data.count - 1 && indexPath.row == data.last!.count - 1 {
            fetchDataWith(pageNumber: indexPath.section + 2, andReplacement: false)
        }
    }
}
