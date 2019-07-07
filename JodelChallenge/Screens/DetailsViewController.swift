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
    @IBOutlet weak var detailsTitel: UILabel!
    
    var data: Dictionary<AnyHashable, Any>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageInformation = data {
            let imageUrl = imageInformation["url"] as! URL
            let title = imageInformation["title"] as! String
            
            if let imageData = try? Data(contentsOf: imageUrl) {
                let image = UIImage(data: imageData)
                detailsImage.image = image
                detailsTitel.text = title
            }
        }
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
