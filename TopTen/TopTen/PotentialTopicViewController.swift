//
//  PotentialTopicTableViewController.swift
//  TopTen
//
//  Created by Jeanie Jung on 4/23/16.
//  Copyright © 2016 Ruijing and Jeanie. All rights reserved.
//

import UIKit

class PotentialTopicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var potentialTopicTableView: UITableView!
    @IBOutlet var timer: UILabel!
    @IBOutlet var topicSuggestTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.potentialTopicTableView.delegate = self
        self.potentialTopicTableView.dataSource = self
        setTimer()
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
        return 1
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PotentialTopicCell", forIndexPath: indexPath) as! PotentialTopicTableViewCell

        // Configure the cell...

        return cell
    }
    
    func setTimer() {
        
        let date = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let newDate = cal.startOfDayForDate(date)
        
        let intervalDate = newDate.timeIntervalSinceNow
        let interval = Int(intervalDate)
        let seconds = 60 - ((-1 * interval) % 60)
        let minutes = 60 - (((-1 * interval) / 60) % 60)
        let hours = 24 - ((-1 * interval) / 3600)
        timer.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
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
