//
//  ItemgetViewController.swift
//  ava
//
//  Created by DevTeam on 2015. 4. 27..
//  Copyright (c) 2015년 DevTeam. All rights reserved.
//

import UIKit

class ItemgetViewController: UIViewController {

    let preferences = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var weeklyItemButton: UIButton!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var weeklyItem1: UIImageView!
    @IBOutlet weak var weeklyItem2: UIImageView!
    @IBOutlet weak var weeklyItem3: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //Nothing
    }
    
    override func viewWillAppear(animated: Bool) {
        
        println("viewWillAppered")
        // 서버의상태를 읽어서 점검중인지 파악한다.
        if preferences.boolForKey("autoLogin"){
            logout()
        }
        // 현재 상태에 맞는 버튼을 뿌려준다.
        getState()
    }
    
    
    func getState(){
        let getStateUrl = NSURL(string: "http://www.pmang.com/m/ava/event/app_event/index.nwz/")
        let request = NSMutableURLRequest(URL: getStateUrl!)
        request.HTTPMethod = "POST"
        request.addValue("serviceapp", forHTTPHeaderField: "from")
        request.addValue("Service-app/AvaSupplySection", forHTTPHeaderField: "User-agent")
        var postString = "ctrl=getMainInfo"
        var loginState = preferences.objectForKey("loginState") as? Bool
        println("Loginstate Is - \(loginState)")
        if preferences.boolForKey("loginState") {
            if let accessToken = preferences.objectForKey("accessToken") as? String{
                if let ssid = preferences.objectForKey("ssid") as? String{
                    postString = "ctrl=getMainInfo&access_token="+(accessToken)+"&ssid="+(ssid)
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
                //println(parseJSON)

                let todayItem = parseJSON["today_item"] as! NSDictionary
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    
                    // Set Item image, name & description
                    self.itemName.text = todayItem["item_name"] as? String
                    self.itemDesc.text = todayItem["memo"] as? String
                    let itemtype = todayItem["reward_type"] as? String
                    let itemid   = todayItem["reward_value"] as? String
                    var imageUrl = NSURL(string: "http://file.pmang.kr/images/pmang/mobileapp/ava/"+itemtype!+"/"+itemid!+".jpg")
                    //imageUrl = NSURL(string: "http://file.pmang.kr/images/pmang/mobileapp/ava/I/12088.jpg")
                    if let imageData = NSData(contentsOfURL: imageUrl!){
                        self.itemImage.image = UIImage(data: imageData)
                    }
                    
                    var todayReward = parseJSON["my_today_reward"] as! String
                    var todayRewardCount = todayReward.toInt()
                    
                    // If logged in, set Image to LogoutIMG and set onclicklistener to logout()
                    self.mainButton.removeTarget(nil, action: "logoutAction", forControlEvents: .AllEvents)
                    
                    if parseJSON["isLogged"] as! String == "0" {
                        self.mainButton.setImage( UIImage(named: "main_log_out") as UIImage!, forState: .Normal)
                        self.mainButton.addTarget(self, action: "loginAction:", forControlEvents: .TouchUpInside)
                    }
                    else if parseJSON["isChar"] as! String == "0" {
                        self.mainButton.setImage( UIImage(named: "main_log_nocharacter") as UIImage!, forState: .Normal)
                    }
                    else if todayRewardCount > 0 {
                        self.mainButton.setImage( UIImage(named: "main_log_rewardcomplete") as UIImage!, forState: .Normal)
                    }
                    else{
                        self.mainButton.setImage( UIImage(named: "main_log_rewardget") as UIImage!, forState: .Normal)
                        self.mainButton.addTarget(self, action: "getItem1Action:", forControlEvents: .TouchUpInside)
                    }
                    
                    
                }
                
                //my_week_reward_cnt 이번주 몇개받았나
                //my_today_reward 오늘아이템 받았나
                //my_is_week_reward ??뭐니이건
                //isLogged 로그인했는지 여부
                //isChar 캐릭터가 있는지 여부
                
                
                //item_id - reward_value 오늘의아이템 아이디
                //item_type - reward_type 오늘의아이템 종류
                //item_name - 오늘의아이템 이름
                //short_desc - memo 아이템설명
                
                //http://file.pmang.kr/images/pmang/mobileapp/ava/ itemtype / itemid . jpg
                
            }

        }
        task.resume()
        
    }
    
    //Listener Group
    func loginAction(sender: AnyObject){
        println(" - loginAction Called")
        performSegueWithIdentifier("loginView", sender: self)
    }
    func logoutAction(sender: AnyObject){
        println(" - logoutAction Called")
        logout()
    }
    func logout(){
        println("Logout called")
        preferences.setObject(false, forKey: "loginState")
        preferences.synchronize()
    }
    
    func getItem1Action(sender: AnyObject){
        println(" - getItem1Action Called")
        let getStateUrl = NSURL(string: "http://www.pmang.com/m/ava/event/app_event/index.nwz/")
        let request = NSMutableURLRequest(URL: getStateUrl!)
        request.HTTPMethod = "POST"
        request.addValue("serviceapp", forHTTPHeaderField: "from")
        request.addValue("Service-app/AvaSupplySection", forHTTPHeaderField: "User-agent")
        var postString = "ctrl=getItem1"
        
        if preferences.boolForKey("loginState") {
            if let accessToken = preferences.objectForKey("accessToken") as? String{
                if let ssid = preferences.objectForKey("ssid") as? String{
                    postString = "ctrl=getItem1&access_token="+(accessToken)+"&ssid="+(ssid)
                }
            }
        }
        else{
            let alertController = UIAlertController(title: "문제발생", message:
                "로그인 후 이용해주세요", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
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

                    switch parseJSON["result"] as! String{
                    case "ERROR" :
                        let alertController = UIAlertController(title: "문제발생", message:
                            "로그인 후 이용해주세요", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    
                    case "ALREADY" :
                        let alertController = UIAlertController(title: "문제발생", message:
                            "이미 지급받으셨습니다.", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)

                    case "OK" :
                        var msg = ""
                        if parseJSON["is_first"] as! String != "0"{
                            msg = "오늘의 아이템과 아바 보급창고 다운로드 보상인 깜짝보상을 보관함으로 발송했습니다."
                        }
                        else{
                            msg = "아이템을 보관함으로지급했습니다."
                        }
                        let alertController = UIAlertController(title: "문제발생", message:
                            msg, preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)

                    default:
                        break
                    }
                    self.viewWillAppear(true)
                }
            }
            
        }
        task.resume()
    }
    
    func getItem2Action(sender: AnyObject){
        println(" - getItem2Action Called")
    }
    
    
    
}

