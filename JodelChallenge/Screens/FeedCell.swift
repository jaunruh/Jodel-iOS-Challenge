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
    var data: Dictionary<AnyHashable, Any>?
    
    public func configure(with imageInformation : Dictionary<AnyHashable, Any>) {
        let imageUrl = imageInformation["url"] as! URL
        let title = imageInformation["title"] as! String
        data = imageInformation
        if let data = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: data)
            imageView.image = image
            titleLabel.text = title
        }
    }
}
