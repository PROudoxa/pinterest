//
//  Board.swift
//  PinterestV
//
//  Created by Alex Voronov on 30.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import Foundation


class Board {
    
    // MARK: Properties
    
    //var counts: [String: Int]
    var createdAt: String?
    //var creator: [String: String]
    var description: String?
    var id: String?
    //var image: [Any: Any]
    var imageUrlString: String?
    var name: String?
    //var privacy: String?
    //var reason: String?
    //var urlString: String?
    var creatorId: String?
    var pins: [Pin] = []
    
    
    // MARK: Initializers
    init() {}
    
    init(createdAt: String?, description: String?, id: String?, imageUrlString: String?, name: String?, creatorId: String?, pins: [Pin]) {
        self.createdAt = createdAt
        self.description = description
        self.id = id
        self.imageUrlString = imageUrlString
        self.name = name
        self.creatorId = creatorId
    }
}
