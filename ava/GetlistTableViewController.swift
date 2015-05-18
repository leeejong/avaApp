//
//  GetlistTableViewController.swift
//  ava
//
//  Created by DevTeam on 2015. 5. 3..
//  Copyright (c) 2015년 DevTeam. All rights reserved.
//

import UIKit

class GetlistTableViewController: UITableViewController {
    
    struct History {
        var itemName:String
        var itemType:String
        var itemDate:String
        init(){
            itemName = "ItemName"
            itemType = "ItemType"
            itemDate = "ItemDate"
        }
    }
    
    var history : [ History ] = []
    let preferences = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getHistory() {
        println(" - getHistory Called")
        let getStateUrl = NSURL(string: "http://www.pmang.com/m/ava/event/app_event/index.nwz/")
        let request = NSMutableURLRequest(URL: getStateUrl!)
        request.HTTPMethod = "POST"
        request.addValue("serviceapp", forHTTPHeaderField: "from")
        request.addValue("Service-app/AvaSupplySection", forHTTPHeaderField: "User-agent")
        var postString = "ctrl=getHistory"
        
        if preferences.boolForKey("loginState") {
            if let accessToken = preferences.objectForKey("accessToken") as? String{
                if let ssid = preferences.objectForKey("ssid") as? String{
                    postString = "ctrl=getHistory&access_token="+(accessToken)+"&ssid="+(ssid)
                }
            }
        }
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil{
                println("Error occured =\(error)")
                return
            }
            
            let responseString = NSString(data: data, encoding: CFStringConvertEncodingToNSStringEncoding(0x0422) )!
            
            var err: NSError?
            
            let data2 : NSData? = responseString.dataUsingEncoding(NSUTF8StringEncoding)
            
            var json = NSJSONSerialization.JSONObjectWithData(data2!, options: .MutableContainers, error: &err) as? NSDictionary
            
            if let parseJSON = json {
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                    let historyData = parseJSON["history"] as! NSArray
                    for eachHistory in historyData{
                        
                        var item = History()
                        item.itemName = eachHistory["item_name"] as! String
                        item.itemType = eachHistory["item_type"] as! String
                        item.itemDate = eachHistory["reg_date"] as! String
                        
                        self.history.append(item)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        println("View will appear called @ GetListView")
        history.removeAll(keepCapacity: false)
        self.tableView.reloadData()
        getHistory()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if history.count != 0{
            return 1
        }
        return 0
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    private struct Storyboard {
        static let CellReuseIdentifier = "History"
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! HistoryTableViewCell
        
        
        cell.history = self.history[indexPath.row]
        
        return cell
    }
    

}
