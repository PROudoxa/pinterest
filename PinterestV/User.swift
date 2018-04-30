//
//  User.swift
//  PinterestV
//
//  Created by Alex Voronov on 29.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import Foundation


struct User {
    
    // MARK: Properties
    var accountType: String?
    var bio: String?
    var counts: Counts
    var createdAt: String?
    var firstName: String?
    var id: String?
    var imageUrl: String?
    var lastName: String?
    var url: String?
    var username: String?
    var boardsArray: [Board] = []
    
    // MARK: Initializers
    init(accountType: String?, bio: String?, createdAt: String?, firstName: String?, id: String?, imageUrl: String?, lastName: String?, url: String?, username: String?, boards: Int, followers: Int, following: Int, pins: Int, boardsArray: [Board]) {
        
        self.accountType = accountType
        self.bio = bio
        self.createdAt = createdAt
        self.firstName = firstName
        self.id = id
        self.imageUrl = imageUrl
        self.lastName = lastName
        self.url = url
        self.username = username
        self.boardsArray = boardsArray
        self.counts = Counts(boards: boards, followers: followers, following: following, pins: pins)
    }
}


struct Counts {
    
    // MARK: Properties
    var boards: Int = 0
    var followers: Int = 0
    var following: Int = 0
    var pins: Int = 0
    
    // MARK: Initializers
    init() {}
    
    init(boards: Int, followers: Int, following: Int, pins: Int) {
        self.boards = boards
        self.followers = followers
        self.following = following
        self.pins = pins
    }
}
