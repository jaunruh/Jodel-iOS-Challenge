//
//  FlickrObject.swift
//  JodelChallenge
//
//  Created by Johannes Aram Unruh on 10.07.19.
//  Copyright © 2019 Jodel. All rights reserved.
//

import Foundation

@objc public class FlickrObject: NSObject {
    // Required properies
    var id: String! = nil
    var title: String! = nil
    var url: URL! = nil
    
    // Optional properties
    let farm: String?
    let isFamily: Bool?
    let isFriend: Bool?
    let isPublic: Bool?
    let owner: String?
    let secret: String?
    let server: Int?
    
    // A codable/decodable approach would be more convenient in practice
    @objc init?(with dataDict: Dictionary<AnyHashable, Any>) {
        self.farm = dataDict["farm"] as? String
        self.isFamily = dataDict["isfamily"] as? Bool
        self.isFriend = dataDict["isfriend"] as? Bool
        self.isPublic = dataDict["ispublic"] as? Bool
        self.owner = dataDict["owner"] as? String
        self.secret = dataDict["secret"] as? String
        self.server = dataDict["server"] as? Int
        
        // Failable initializer, because if the below data is missing we should not show a cell
        if let id = dataDict["id"] as? String,
            let title = dataDict["title"] as? String,
            let url = dataDict["url"] as? URL {
            self.id = id
            self.title = title
            self.url = url
        } else {
            return nil
        }
    }
}
