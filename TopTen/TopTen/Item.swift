//
//  Item.swift
//  TopTen
//
//  Created by Jeanie Jung on 4/23/16.
//  Copyright © 2016 Ruijing and Jeanie. All rights reserved.
//

import UIKit

class Item: NSObject {
    var itemDescription: String!
    var upvotes: Int!
    var downvotes: Int!
    var votes: Int!
    
    func calculateVotes() -> Int {
        votes = upvotes - downvotes
        return votes
    }

}
