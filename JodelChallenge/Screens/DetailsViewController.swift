//
//  DetailsViewController.swift
//  JodelChallenge
//
//  Created by Johannes Aram Unruh on 07.07.19.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var detailsTitle: UITextView!
    
    
    var flickrObject: FlickrObject? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageInformation = flickrObject {
            if let imageData = try? Data(contentsOf: imageInformation.url) {
                let image = UIImage(data: imageData)
                detailsImage.image = image
                detailsTitle.text = imageInformation.title
            }
        }
        setupView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// Custom Methods
extension DetailsViewController {
    
    func setupView() {
        self.detailsImage.layer.cornerRadius = 10
        self.detailsImage.layer.borderWidth = 1.0
        self.detailsImage.layer.borderColor = UIColor.clear.cgColor
        self.detailsImage.layer.masksToBounds = true
    }
}
