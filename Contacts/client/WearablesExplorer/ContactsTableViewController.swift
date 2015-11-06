//
//  ContactsTableViewController.swift
//  WearablesExplorer
//
//  Created by Andrew Trice on 10/23/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

import Foundation
import UIKit
import IMFCore

class ContactsTableViewController: UITableViewController {
    
    var listResults:[AnyObject]?
    var selectedId:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Contacts"
        
        DataManager.instance.getList { (results) -> Void in
            
            self.listResults = results
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ( self.listResults != nil ) {
            return self.listResults!.count;
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("listCell") as? UITableViewCell
        if ( cell == nil ) {
            cell = UITableViewCell()
        }
        
        if let data = self.listResults![indexPath.row] as? [String: AnyObject],
            let lastName = data["lastName"] as? String,
            let firstName = data["firstName"] as? String {
                
            cell!.textLabel?.text = lastName + ", " + firstName
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if let data = self.listResults![indexPath.row] as? [String: AnyObject],
            let id : String = data["id"] as? String {
        
            println(id)
            
                if (String(id) != nil) {
                    
                    selectedId = id;
                    self.performSegueWithIdentifier("showDetails", sender: self);
                }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetails") {
            var vc:UserDetailsViewController = segue.destinationViewController as! UserDetailsViewController;
            vc.requestDataForId(selectedId);
        }
    }
    
}