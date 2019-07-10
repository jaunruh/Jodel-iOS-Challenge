//
//  FeedCell.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

class FeedCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var flickrObject: FlickrObject?
    
    public func configure(with imageInformation : FlickrObject) {
        flickrObject = imageInformation
        if let data = try? Data(contentsOf: imageInformation.url) {
            let image = UIImage(data: data)
            imageView.image = image
            titleLabel.text = imageInformation.title
        }
    }
}
