//
//  uselessCodes.swift
//  ava
//
//  Created by DevTeam on 2015. 5. 7..
//  Copyright (c) 2015년 DevTeam. All rights reserved.
//

import Foundation


func getState2(){
    
    let urlPath: String = "http://www.pmang.com/m/ava/event/app_event/index.nwz/"
    var url: NSURL = NSURL(string: urlPath)!
    var request1: NSMutableURLRequest = NSMutableURLRequest(URL: url)
    
    request1.HTTPMethod = "POST"
    var stringPost="ctrl=getMainInfo" // Key and Value
    
    let data = stringPost.dataUsingEncoding(NSUTF8StringEncoding)
    
    request1.timeoutInterval = 60
    request1.HTTPBody=data
    request1.HTTPShouldHandleCookies=false
    
    let queue:NSOperationQueue = NSOperationQueue()
    
    NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        
        let responseString = NSString(data: data, encoding: CFStringConvertEncodingToNSStringEncoding(0x0422) )!
        
        println("response data is = \(responseString)")
        
        let myData : NSData? = responseString.dataUsingEncoding(NSUTF8StringEncoding)
        
        var err: NSError
        
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(myData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        println("ASynchronous\(jsonResult)")
        
        
        
    })
    
    
}
