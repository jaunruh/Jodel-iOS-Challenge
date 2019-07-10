//
//  FeedViewController.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

class FeedViewController : UICollectionViewController {
    
    var flickrData: [[FlickrObject]] = []
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
        
        fetchDataWith(pageNumber: 1, andReplacement: false, andCompletion: { [weak self] in
            self?.hideLoading()
        })
    }

    // Override segue function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            if let destinationVC = segue.destination as? DetailsViewController {
                if let cell = sender as? FeedCell {
                    destinationVC.flickrObject = cell.flickrObject
                }
            }
        }
    }
}

// Custom methods
extension FeedViewController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        // Currently I have the following issue here:
        // When I pull to refresh, the spinner shows only for a short time.
        // probably, because i dont remove the data...
        fetchDataWith(pageNumber: 1, andReplacement: true, andCompletion: nil)
        refreshControl.endRefreshing()
    }
    
    func fetchDataWith(pageNumber: Int, andReplacement shouldReplace: Bool, andCompletion completion: (() -> Void)?) {
        FlickrApi.fetchPhotos(withPageNumber: Int32(pageNumber), andCompletion: { [weak self] (flickrObjectArray, error) in
            usleep(2000000) // for debugging purposes
            if shouldReplace {
                self?.flickrData = [flickrObjectArray ?? []]
            } else {
                self?.flickrData.append(flickrObjectArray ?? [])
            }
            DispatchQueue.main.async(execute: {
                self?.collectionView?.reloadData()
                completion?()
            })
        })
    }
    
    func showLoading() {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let indicator = UIActivityIndicatorView(frame: rect)
        indicator.color = .darkGray
        self.collectionView.backgroundView = indicator
        indicator.startAnimating()
    }
    func hideLoading() {
        self.collectionView.backgroundView = nil
    }
}

// MARK: UICollectionViewDataSource
extension FeedViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if flickrData.count > 0 {
            return flickrData.count
        } else {
            showLoading()
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrData[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.configure(with: self.flickrData[indexPath.section][indexPath.row])
        return cell
    }
    
    // Set section header and footer
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == "UICollectionElementKindSectionHeader", let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader {
            sectionHeader.sectionHeaderLabel.text = "Page \(indexPath.section + 1)"
            return sectionHeader
        }
        if kind == "UICollectionElementKindSectionFooter", let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionFooter", for: indexPath) as? SectionFooter {
            return sectionFooter
        }
        return UICollectionReusableView()
    }
    
    // Called before footer or header will show up on screen
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        if view.isKind(of: SectionFooter.self) {
            if indexPath.section == self.flickrData.count - 1 {
                view.isHidden = false
                fetchDataWith(pageNumber: indexPath.section + 2, andReplacement: false, andCompletion: {
                    view.isHidden = true
                })
            } else {
                view.isHidden = true
            }
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
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
}
