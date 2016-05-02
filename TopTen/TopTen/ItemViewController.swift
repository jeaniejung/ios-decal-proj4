//
//  ItemTableViewController.swift
//  TopTen
//
//  Created by Ruijing Li on 4/20/16.
//  Copyright © 2016 Ruijing and Jeanie. All rights reserved.
//

import UIKit
import Parse

class ItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var itemTableView: UITableView!
    @IBOutlet var topicName: UILabel!
    @IBOutlet var itemSuggestTextField: UITextField!
    var topicID: String!
    var itemArray: [PFObject]!
    var topic: Topic!
    var itemTitleToID: [String : String]!
    var itemTitleToVotes: [String : Int]!
    @IBAction func upVote(sender: AnyObject) {
        let buttonRow = sender.tag
        let up = PFObject(className:"upvoteItem")
        var rowIndex = sender.tag
        let myItem = itemArray[rowIndex]
        let prefs = NSUserDefaults.standardUserDefaults()
        if let name = prefs.stringForKey("email") {
            up["username"] = name
        }
        up["itemID"] = myItem.objectId
        up.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
        self.itemTitleToVotes[String(myItem["title"])] = self.votesOf(myItem)
        updateVotes()
    }
    
    @IBAction func downVote(sender: AnyObject) {
        let buttonRow = sender.tag
        let down = PFObject(className:"downvoteItem")
        var rowIndex = sender.tag
        let myItem = itemArray[rowIndex]
        let prefs = NSUserDefaults.standardUserDefaults()
        if let name = prefs.stringForKey("email") {
            down["username"] = name
        }
        down["itemID"] = myItem.objectId
        down.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
        self.itemTitleToVotes[String(myItem["title"])] = self.votesOf(myItem)
        updateVotes()
        
    }
    func updateVotes() {
        self.itemTableView.reloadData()

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        itemArray = [PFObject]()

        itemTitleToID = [String : String]()
        itemTitleToVotes = [String : Int]()
        retrieveItemsOfTopic()
        let delay = 5.0 * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            self.itemTableView.reloadData()
//            print(self.topicList)
            
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.itemTableView.delegate = self
        self.itemTableView.dataSource = self

    }
    
    override func viewWillDisappear(animated: Bool) {
        let sourceVC = navigationController?.viewControllers.first as! TopicTableViewController
//        sourceVC.currentTopic = topic
//        sourceVC.updatedItemList = itemsList
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemTableViewCell
        // Configure the cell...
        let itemString = itemArray[indexPath.row]["title"] as! String
        cell.itemName.text = itemString
        cell.itemRank.text = String(indexPath.row + 1)
        cell.votes.text = String(itemTitleToVotes[itemString]!)
        cell.tag = indexPath.row
        print(cell.itemRank.text)
        return cell
        
    }
    
    @IBAction func addItem(sender: UIButton) {
        if itemArray.count < 10  && itemSuggestTextField?.text != "" {
            let first = PFObject(className:"Item")
            first["title"] = itemSuggestTextField.text
            first["parent"] = topicID
            first.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
            itemArray.append(first)
            itemSuggestTextField.text = ""
//            sortItems()
        }
        itemTableView.reloadData()
    }
    
    func sortItems() {
        itemArray = itemArray.sort({a, b in itemTitleToVotes[a["title"] as! String]! > itemTitleToVotes[b["title"] as! String]!})
    }
    
    func votesOf(item: PFObject) -> Int{
        var upvotes = 0
        var downvotes = 0
        let query1 = PFQuery(className: "upvoteItem")
        query1.whereKey("itemID", equalTo: item.objectId!)
        query1.findObjectsInBackgroundWithBlock {
            (items: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                upvotes = items!.count
                
            }else{
            }
        }
        let query = PFQuery(className: "downvoteItem")
        query.whereKey("itemID", equalTo: item.objectId!)
        query.findObjectsInBackgroundWithBlock {
            (items: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                downvotes = items!.count
                
            }else{
            }
        }
        return upvotes - downvotes
    }
    
    func retrieveItemsOfTopic() {
        let query = PFQuery(className: "Item")
        query.whereKey("parent", equalTo: topicID)
        query.findObjectsInBackgroundWithBlock {
            (items: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for item in items! {
                    if let myItem = item as PFObject? {
                        let titleString = myItem["title"] as! String
                        self.itemArray.append(myItem)
                        self.itemTitleToID[titleString] = myItem.objectId
                        self.itemTitleToVotes[titleString] = self.votesOf(item)
                    }                }
                self.itemTableView.reloadData()
                
            }else{
                self.itemTableView.reloadData()
            }
        }
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
