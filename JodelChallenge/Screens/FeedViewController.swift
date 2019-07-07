//
//  FeedViewController.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

class FeedViewController : UICollectionViewController {
    
    var data : [Dictionary<AnyHashable, Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FlickrApi.fetchPhotos { [weak self] (responseArray, error) in
            self?.data = responseArray ?? []
            DispatchQueue.main.async(execute: {
                self?.collectionView?.reloadData()
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCell
        cell.configure(with: data[indexPath.row])
        return cell
    }
}
