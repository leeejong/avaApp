//
//  GetlistViewController.swift
//  ava
//
//  Created by DevTeam on 2015. 5. 3..
//  Copyright (c) 2015년 DevTeam. All rights reserved.
//

import UIKit

class GetlistViewController: UIViewController {

    @IBOutlet weak var getListTableView: UITableView!
    
    var country  = [ "Seoul", "Incheon", "Newyork"]
    var capitals = [ "Seongsu", "Mayweather", "paquiao"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
