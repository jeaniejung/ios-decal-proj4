//
//  Topic.swift
//  TopTen
//
//  Created by Jeanie Jung on 4/23/16.
//  Copyright © 2016 Ruijing and Jeanie. All rights reserved.
//

import UIKit
import Parse



class Topic: NSObject {
//    func createTopic(name: String!) {
//        var topic = PFObject(className:"Topic")
//        topic["name"] = name
//        topic["clickcount"] = 0
//    }
//    
//    func incrementClick() {
//        topic["clickcount"] = Int(topic["clickcount"]) + 1
//    }
//    topic.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//        print("Topic has been saved.")
//    }
//    
//    
    
//    var topic = PFObject(className:"Topic")
//    topic["name"] = "asdf"
    
    var topicTitle: String!
    var items : [Item]!

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