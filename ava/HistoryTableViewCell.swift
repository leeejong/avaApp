//
//  HistoryTableViewCell.swift
//  ava
//
//  Created by DevTeam on 2015. 5. 12..
//  Copyright (c) 2015년 DevTeam. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemType: UILabel!
    @IBOutlet weak var itemDate: UILabel!
    
    struct History {
        var itemName:String
        var itemType:String
        var itemDate:String
    }
    
    
    var history : GetlistTableViewController.History? {
        didSet{
            updateUI()
        }
    }
    
    func updateUI(){
        itemName?.text = nil
        itemType?.text = nil
        itemDate?.text = nil
        
        if let history = self.history
        {
            println(history)
            itemName?.text = history.itemName
            itemType?.text = history.itemType
            itemDate?.text = history.itemDate
        }
    }
}
