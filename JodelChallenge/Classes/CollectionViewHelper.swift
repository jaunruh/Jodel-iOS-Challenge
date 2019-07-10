//
//  CollectionViewHelper.swift
//  JodelChallenge
//
//  Created by Johannes Aram Unruh on 10.07.19.
//  Copyright © 2019 Jodel. All rights reserved.
//

import Foundation
import UIKit

// Class for displaying a message in the backgroundView of a ViewController.
// Used for error handling in the feed.
class CollectionViewHelper {
    class func EmptyMessage(message:String, viewController:UICollectionViewController) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        viewController.collectionView.backgroundView = messageLabel;
    }
}
