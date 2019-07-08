//
//  SectionFooter.swift
//  JodelChallenge
//
//  Created by Johannes Aram Unruh on 08.07.19.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

class SectionFooter: UICollectionReusableView {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func layoutSubviews() {
        self.loadingIndicator.startAnimating()
//        self.isHidden = false
    }
}
