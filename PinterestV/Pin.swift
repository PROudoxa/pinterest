//
//  Pin.swift
//  PinterestV
//
//  Created by Alex Voronov on 30.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import Foundation

struct Pin {
    
    // MARK: Properties
    
    //var attribution: String?
    //var board: [String: Any]
    //var color: String
    //var counts: [String: Int]
    var createdAt: String?
    //weak var creator: User?
    var id: String?
    var imageUrlString: String?
    //var linkString: String
    //var media: [String: [String: Any]]
    //var metadata: [String: Any]
    var note: String?
    //var originalLink: String
    //var url: String
    var boardId: String?
    var creatorId: String?
    
    // MARK: Initializers
    init() {}
    
    init(createdAt: String?, id: String?, imageUrlString: String, note: String?, boardId: String?, creatorId: String?) {
        self.createdAt = createdAt
        self.id = id
        self.imageUrlString = imageUrlString
        self.note = note
        self.boardId = boardId
        self.creatorId = creatorId
    }
    
//    func getInfo(for pin: Pin) -> (String?, String?) {
//        return (imageUrlString, note)
//    }
}
