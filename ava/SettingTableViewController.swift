//
//  SettingTableViewController.swift
//  ava
//
//  Created by DevTeam on 2015. 5. 11..
//  Copyright (c) 2015년 DevTeam. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    let preferences = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var alertSwitch: UISwitch!
    @IBOutlet weak var alertEventSwitch: UISwitch!
    @IBOutlet weak var alertUpdateSwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func alertSwitchAction(sender: UISwitch) {
        if sender.on{
            preferences.setBool(true, forKey:"alertEvent")
            preferences.setBool(true, forKey:"alertUpdate")
            alertEventSwitch.setOn(true, animated: true)
            alertUpdateSwitch.setOn(true, animated: true)
        }
        else{
            preferences.setBool(false, forKey:"alertEvent")
            preferences.setBool(false, forKey:"alertUpdate")
            alertEventSwitch.setOn(false, animated: true)
            alertUpdateSwitch.setOn(false, animated: true)
        }
        preferences.synchronize()
        
        
    }
    
    @IBAction func eventSwitchAction(sender: UISwitch) {
        if sender.on{
            preferences.setBool(true, forKey:"alertEvent")
            if alertUpdateSwitch.on {
                alertSwitch.setOn(true, animated: true)
            }
        }
        else{
            preferences.setBool(false, forKey:"alertEvent")
            alertSwitch.setOn(false, animated: true)
        }
        preferences.synchronize()
    }
    
    @IBAction func updateSwitchAction(sender: UISwitch) {
        if sender.on{
            preferences.setBool(true, forKey:"alertUpdate")
            if alertEventSwitch.on {
                alertSwitch.setOn(true, animated: true)
            }
        }
        else{
            preferences.setBool(false, forKey:"alertUpdate")
            alertSwitch.setOn(false, animated: true)
        }
        preferences.synchronize()
    }
    
    override func viewWillAppear(animated: Bool) {
        println("View will appear called @ SettingView")
        var alertEventState = preferences.boolForKey("alertEvent")
        var alertUpdateState = preferences.boolForKey("alertUpdate")
        
        if alertEventState&&alertUpdateState{
            alertSwitch.setOn(true, animated: true)
            alertEventSwitch.setOn(true, animated: true)
            alertUpdateSwitch.setOn(true, animated: true)
        }
        else if (alertEventState == true) {
            alertSwitch.setOn(false, animated: true)
            alertEventSwitch.setOn(true, animated: true)
            alertUpdateSwitch.setOn(false, animated: true)
        }
        else if (alertUpdateState == true){
            alertSwitch.setOn(false, animated: true)
            alertEventSwitch.setOn(false, animated: true)
            alertUpdateSwitch.setOn(true, animated: true)
        }
        else{
            alertSwitch.setOn(false, animated: true)
            alertEventSwitch.setOn(false, animated: true)
            alertUpdateSwitch.setOn(false, animated: true)
        }
        
        if preferences.boolForKey("loginState") {
            loginButton.setImage(UIImage (named: "setting_btn_logout") as UIImage!,forState: .Normal)
            loginButton.addTarget(self, action: "logoutAction", forControlEvents: .TouchUpInside)
        }
        else{
            loginButton.setImage(UIImage (named: "setting_btn_login") as UIImage!,forState: .Normal)
            loginButton.addTarget(self, action: "loginAction", forControlEvents: .TouchUpInside)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //처음 뷰가 로드되면
        //Shared Preferences 를 일어서 스위치 상태를 써준다.
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loginAction(){
        println(" - loginAction Called")
        performSegueWithIdentifier("loginView", sender: self)
    }
    
    func logoutAction(){
        println(" - logoutAction Called")
        preferences.setObject(false, forKey: "loginState")
        preferences.synchronize()
        
        loginButton.removeTarget(nil, action: "logoutAction", forControlEvents: .AllEvents)
        loginButton.setImage(UIImage (named: "setting_btn_login") as UIImage!,forState: .Normal)
        loginButton.addTarget(self, action: "loginAction", forControlEvents: .TouchUpInside)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 10
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
