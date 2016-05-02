//
//  ViewController.swift
//  TopTen
//
//  Created by Ruijing Li on 4/20/16.
//  Copyright © 2016 Ruijing and Jeanie. All rights reserved.
//


import UIKit
import Parse

class LoginViewController: UIViewController {
    let userToIDString = "cHLdDIagBH"
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBAction func signInMethod(sender: AnyObject) {
        initiateMapIfNotExist()
        let username = UsernameTextField.text
        let password = PasswordTextField.text
        dealWithNewUsers(username!, password: password!, sender: sender)
        
    }

    @IBAction func signUpMethod(sender: AnyObject) {
        initiateMapIfNotExist()
        let username = UsernameTextField.text
        let password = PasswordTextField.text
        let newUser = PFObject(className: "Username")
        newUser["email"] = username
        newUser["password"] = password
        var newUserObjectID = ""
        newUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("Object has been saved.")
                newUserObjectID = newUser.objectId! as String
                print("ID: " + newUserObjectID)
            }
        }
        let delay = 1.0 * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            // here code perfomed with delay
            print("Here is id " + newUserObjectID)
            self.addNewUser(username!, password: password!, id: newUserObjectID, sender: sender)
            
        })
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let prefs = NSUserDefaults.standardUserDefaults()
        if let name = prefs.stringForKey("email") {
//            display TOPICVIEW
            
            
        } else {
//            display LOGINVIEW
            
        }

    }
    func dealWithNewUsers(email:String, password: String, sender: AnyObject) {
        let query = PFQuery(className:"userToID")
        query.getObjectInBackgroundWithId(String(userToIDString)) {
            (userToID: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let userToID = userToID {
                var myMap = userToID["map"] as? [String:String]

                if let val = myMap![email] {
//                    retrieve user
                    let newUser = PFQuery(className:"Username")
//                    retrieve user ID
                    let query = PFQuery(className:"userToID")
                    query.getObjectInBackgroundWithId(self.userToIDString) {
                        (userToID: PFObject?, error: NSError?) -> Void in
                        if error == nil && userToID != nil {
                            print(userToID)
                        } else {
                            print(error)
                        }
                    }
                    let myMap = userToID["map"] as! [String:String]
                    let myID = myMap[email]
                    
                    var realPassword  = " "

                    newUser.getObjectInBackgroundWithId(myID!) {
                        (myUniqueUser: PFObject?, error: NSError?) -> Void in
                        if error == nil && myUniqueUser != nil {
                            print(myUniqueUser)
                        } else {
                            print(error)
                        }
                        realPassword = myUniqueUser!["password"] as! String
                        print("Real password inside get" + realPassword)
                    }
                    let delay = 1.0 * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        print("Real Password " +  realPassword)
                        print("Password " + password)
                        if password == realPassword {
                            self.allowLogin(email, password: password, id: myID!, sender: sender)
                        } else {
                            self.displayError()
                        }
                    })
                    
                }
                else {
                    self.displayError()
                }
                userToID.saveInBackground()
            }
        }

    }
    func displayError() {
        let alertController = UIAlertController(title: "Wrong Username/Password", message: "Sign up if new user", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    func displayExistingUserError() {
        let alertController = UIAlertController(title: "Username already exists", message: "Please try a different username", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    func addNewUser(email: String, password: String, id: String, sender: AnyObject) {
        let query = PFQuery(className:"userToID")
        query.getObjectInBackgroundWithId(userToIDString) {
            (userToID: PFObject?, error: NSError?) -> Void in
            if error !=
                nil {
                print(error)
            } else if let userToID = userToID {
                print("Hi")
                var myMap = userToID["map"] as! [String : String]
                if let targetID = myMap[email] {
//                    email already exists
                    self.displayExistingUserError()
                } else {
                    myMap[email] = id
                    print("1")
//                    print(myMap[email])
                    userToID["map"] = myMap
                    print("2")
                    print(userToID["map"])
                    userToID.saveInBackground()
                    self.allowLogin(email, password: password, id: id, sender: sender)
                }
            }
        }
        
        
    }
    func initiateMapIfNotExist() {
        let query = PFQuery(className:"userToID")
        query.getObjectInBackgroundWithId(String(userToIDString)) {
            (userToID: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let userToID = userToID {
                if let myMap = userToID["map"] {
                    //map already exists
                } else {
                    let myMap = [String:String]()
                    userToID["map"] = myMap
                }
                userToID.saveInBackground()
            }
        }
    }
    
    func allowLogin(email: String, password: String, id: String, sender: AnyObject) {
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setValue(email, forKey: "username")
        prefs.setValue(password, forKey: "password")
        prefs.setValue(id, forKey: "userID")
        performSegueWithIdentifier("loginSuccess", sender: sender)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


