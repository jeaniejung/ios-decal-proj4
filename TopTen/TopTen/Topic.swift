//
//  Topic.swift
//  TopTen
//
//  Created by Jeanie Jung on 4/23/16.
//  Copyright © 2016 Ruijing and Jeanie. All rights reserved.
//

import UIKit

class Topic: NSObject {
    
    var topicTitle: String!
    var items : [Item]!
    var clicks : Int!
    
    func incrementClick() {
        clicks = clicks + 1
    }

    func sortItems() -> [Item] {
        let myItems = items.sort({a, b in a.votes > b.votes})
        return myItems
    }
    func addToItems(a: Item) {
        items.append(a)
        sortItems()
    }
    func getTop() -> Item{
        return items[0]
    }
}