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
        
        setupView()
    }
}

extension FeedCell {
    
    // Setup view: Corner radius and background shadow
    func setupView() {
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1.0
        
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
    }
}
