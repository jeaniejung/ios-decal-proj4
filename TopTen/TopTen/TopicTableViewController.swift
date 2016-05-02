//
//  TopicTableViewController.swift
//  TopTen
//
//  Created by Jeanie Jung on 4/23/16.
//  Copyright © 2016 Ruijing and Jeanie. All rights reserved.
//

import UIKit
import Parse

class TopicTableViewController: UITableViewController {
    var topicList: [Topic]!
    var updatedItemList: [Item]!
    var currentTopic: Topic!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        topicList = [Topic]()
        retrieveTopicList()
        let topic = Topic()
        topic.topicTitle = "BOBA"
        let item = Item()
        item.itemDescription = "Sharetea"
        topic.items = [item]
        topic.clicks = 100
        self.topicList.append(topic)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        if updatedItemList != nil && currentTopic != nil {
            currentTopic.items = updatedItemList
            if topicList.contains(currentTopic) {
                let index = topicList.indexOf(currentTopic)
                topicList.removeAtIndex(index!)
                topicList.append(currentTopic)
            }
            self.tableView.reloadData()
        }
    }
    
    func retrieveTopicList() {
        
        let query = PFQuery(className:"Topic")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("Yes")
                for object in objects! {
                    //Set test to total (assuming self.test is Int)
                    let topic = Topic()
                    topic.topicTitle = object["title"] as! String
                    topic.items = object["items"] as! Array
                    topic.clicks = object["clicks"] as! Int
                    self.topicList.append(topic)
                }
                self.tableView.reloadData()
            }else{
                //Handle error
                //Fake data
                print("Hi")
                let topic = Topic()
                topic.topicTitle = "BOBA"
                let item = Item()
                item.itemDescription = "Sharetea"
                topic.items = [item]
                topic.clicks = 100
                self.topicList.append(topic)
                self.tableView.reloadData()
            }
        }
       
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return topicList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TopicCell", forIndexPath: indexPath) as! TopicTableViewCell
        
         //Configure the cell...
        cell.topicClicks.text = String(topicList[indexPath.row].clicks)
        cell.topicName.text = topicList[indexPath.row].topicTitle
        cell.topicAnswer.text = topicList[indexPath.row].getTop().itemDescription
        cell.num = indexPath.row
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToItemView" {
            let targetVC = segue.destinationViewController as! ItemViewController
            targetVC.topicName = sender?.topicName
            let cell = sender as! TopicTableViewCell
            targetVC.itemsList = topicList[cell.num].items
            targetVC.topic = topicList[cell.num]
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
