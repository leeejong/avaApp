//
//  LoginViewController.swift
//  ava
//
//  Created by DevTeam on 2015. 4. 28..
//  Copyright (c) 2015년 DevTeam. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController {
    let preferences = NSUserDefaults.standardUserDefaults()

    
    @IBOutlet weak var myId: UITextField!
    @IBOutlet weak var myPassword: UITextField!
    
    @IBAction func autologinSwitchAction(sender: UISwitch) {
        if sender.on{
            preferences.setBool(true, forKey: "autoLogin")
        }
        else{
            preferences.setBool(false, forKey: "autoLogin")
        }
        preferences.synchronize()
    }
    
    @IBAction func alertSwitchAction(sender: UISwitch) {
        if sender.on{
            preferences.setBool(true, forKey:"alertEvent")
            preferences.setBool(true, forKey:"alertUpdate")
        }
        else{
            preferences.setBool(false, forKey:"alertEvent")
            preferences.setBool(false, forKey:"alertUpdate")
        }
        preferences.synchronize()
    }
    
    @IBAction func LoginAction(sender: UIButton) {
        
        let loginUrl = NSURL(string: "http://www.pmang.com/gamepub/pubapp/app_login.nwz/")
        
        let request = NSMutableURLRequest(URL:  loginUrl!)
        request.HTTPMethod = "POST"
        request.addValue("serviceapp", forHTTPHeaderField: "from")
        request.addValue("Service-app/AvaSupplySection", forHTTPHeaderField: "User-agent")
        
        let postString = "type=login&userid="+myId.text+"&password="+myPassword.text
        println("postString is ---- \(postString)")
        
        
        //실환경 로그인안되는 문제 있음
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil {
                println("Error occured =\(error)")
                return
            }
            
            println("response is = \(response)")

            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            println("response data is = \(responseString)")
            var err: NSError?
            
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
            
            
            if let parseJSON = json {
                
                let result = parseJSON["result"] as? NSString
                if result == "OK"{
                
                    var loginInfo = parseJSON["login_info"] as! NSDictionary
                    var accessToken = loginInfo["access_token"] as! String
                    var ssid = loginInfo["ssid"] as! String
                    
                    println("Access Token is = \(accessToken)")
                    println("SSID is = \(ssid)")
                    
                    let preferences = NSUserDefaults.standardUserDefaults()
                    
                    preferences.setObject(accessToken, forKey: "accessToken")
                    preferences.setObject(ssid, forKey: "ssid")
                    preferences.setObject(true, forKey: "loginState")
                    
                    preferences.synchronize()
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        preferences.setObject(true, forKey: "loginState")
                        preferences.synchronize()
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    
                    
                }
                else{
                    println("An error occured : loginReturn Value is != OK")
                }
            }
        }
        task.resume()
        
    }
    func back(sender: UIBarButtonItem) {
    
        
        
        
        println("HERE I AMAMAMAMAMAMAMAMAMAM")
        
        println("HERE I AMAMAMAMAMAMAMAMAMAM")
        println("HERE I AMAMAMAMAMAMAMAMAMAM")
        println("HERE I AMAMAMAMAMAMAMAMAMAM")
        println("HERE I AMAMAMAMAMAMAMAMAMAM")
        
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}