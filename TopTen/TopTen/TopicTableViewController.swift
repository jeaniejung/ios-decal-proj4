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
    var topicList = [String]()
    var topicTitleToClicks = [String : Int]()
    var topicTitleToID = [String : String]()
    var topicTitleToBest = [String : String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        createFakeData()
        retrieveTopicList()
        let delay = 1.0 * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            self.tableView.reloadData()
            print(self.topicList)
            
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    func createFakeData() {
        var first = PFObject(className:"Topic")
        first["title"] = "Boba"
        first["clicks"] = 199
        first["best"] = "Ucha"
        first.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    }
    
    func retrieveTopicList() {
        let query = PFQuery(className:"Topic")
        query.findObjectsInBackgroundWithBlock {
            (topics: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if topics!.count == 0 {
                    self.createFakeData()
                }
                for topic in topics! {
                    if let myTopic = topic as PFObject? {
                        let topicTitle = myTopic["title"]! as! String
                        let topicClicks = myTopic["clicks"]! as! Int
                        let topicBest = myTopic["best"]! as! String
                        let topicID = myTopic.objectId! as! String
                        
                        self.topicList.append(topicTitle)
                        self.topicTitleToClicks[topicTitle] = topicClicks
                        self.topicTitleToID[topicTitle] = topicID
                        self.topicTitleToBest[topicTitle] = topicBest
                        print(topicTitle)
                    }
                    //Set test to total (assuming self.test is Int)
                    
                }
                self.tableView.reloadData()
                
            }else{
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
        return self.topicList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TopicCell", forIndexPath: indexPath) as! TopicTableViewCell
        
         //Configure the cell...
        print(topicList.count)
        
        let topicString = topicList[indexPath.row]
        
        cell.topicName.text = topicString as! String
        cell.topicClicks.text = String(topicTitleToClicks[topicString]!)
        cell.topicAnswer.text = String(topicTitleToBest[topicString]!)
        cell.num = indexPath.row
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToItemView" {
            let targetVC = segue.destinationViewController as! ItemViewController
            targetVC.topicName = sender?.topicName
        
            let cell = sender as! TopicTableViewCell
                targetVC.topicID = topicTitleToID[cell.topicName.text!]
//            targetVC.itemsList = topicList[cell.num].items
//            targetVC.topic = topicList[cell.num]
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
