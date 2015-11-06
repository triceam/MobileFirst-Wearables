//
//  InterfaceController.swift
//  WearablesExplorer WatchKit Extension
//
//  Created by Andrew Trice on 10/21/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    var bmc:BluemixConnector?
    var listResults:[AnyObject]?
    
    @IBOutlet var dataTable:WKInterfaceTable?
    @IBOutlet var feedbackLabel:WKInterfaceLabel?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.setTitle("Contacts")
        
        self.bmc = BluemixConnector()
        bmc!.connect("InterfaceController")
        
        
        DataManager.instance.getList { (results) -> Void in
            
            self.listResults = results
            self.feedbackLabel!.setHidden(true)
            self.populateTable()
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        bmc!.sendLogs()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        bmc!.sendLogs()
    }
    
    func populateTable() {
        
        var table : WKInterfaceTable = self.dataTable!;
        table.setNumberOfRows( listResults!.count, withRowType: "tableRow")
        
        var index:Int = 0
        while index < table.numberOfRows {
            var row:WatchTableRow! = table.rowControllerAtIndex(index) as! WatchTableRow
            
            var label:String? = "";
            
            if let data = self.listResults![index] as? [String: AnyObject],
                let lastName = data["lastName"] as? String,
                let firstName = data["firstName"] as? String {
                    
                    label = lastName + ", " + firstName
            }
            row.label.setText(label);
            index++
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
        var data = self.listResults![rowIndex] as? [String: AnyObject]
        return data
    }
    
}
