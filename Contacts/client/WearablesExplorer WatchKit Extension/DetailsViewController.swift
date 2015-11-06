//
//  DetailsViewController.swift
//  WearablesExplorer
//
//  Created by Andrew Trice on 10/26/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

import WatchKit
import Foundation

class DetailsViewController:WKInterfaceController {
    
    @IBOutlet var nameLabel:WKInterfaceLabel?
    @IBOutlet var emailLabel:WKInterfaceLabel?
    @IBOutlet var phoneLabel:WKInterfaceLabel?
    @IBOutlet var streetLabel:WKInterfaceLabel?
    @IBOutlet var cityLabel:WKInterfaceLabel?
    @IBOutlet var stateLabel:WKInterfaceLabel?
    @IBOutlet var firstSeparator:WKInterfaceSeparator?
    @IBOutlet var secondSeparator:WKInterfaceSeparator?
  
    override func awakeWithContext(context: AnyObject?) {
        
        if let selectedItem = context as? [String: AnyObject],
            let id = selectedItem["id"] as? String {
        
            DataManager.instance.getDetail(id, completion: { (result) -> Void in
                
                if let data = result as? [String: AnyObject],
                    let lastName = data["lastName"] as? String,
                    let firstName = data["firstName"] as? String,
                    let street = data["street"] as? String,
                    let city = data["city"] as? String,
                    let state = data["state"] as? String,
                    let zip = data["zip"] as? String,
                    let email = data["email"] as? String,
                    let telephone = data["telephone"] as? String {
                        
                        self.setTitle("User Detail")
                        
                        self.nameLabel!.setText(firstName + " " + lastName)
                        self.emailLabel!.setText(email)
                        self.phoneLabel!.setText(telephone)
                        self.streetLabel!.setText(street)
                        self.cityLabel!.setText(city)
                        self.stateLabel!.setText(state + ", " + zip)
                        
                        let views:[WKInterfaceObject?] = [self.emailLabel, self.phoneLabel, self.streetLabel, self.cityLabel, self.stateLabel, self.firstSeparator, self.secondSeparator]
                        
                        for item in views {
                            
                            item!.setHidden(false)
                        }
                }
                
            })
        }

        
    }
}
