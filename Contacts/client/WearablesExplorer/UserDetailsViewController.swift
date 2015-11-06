//
//  UserDetailsViewController.swift
//  WearablesExplorer
//
//  Created by Andrew Trice on 10/23/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

import Foundation
import UIKit

class UserDetailsViewController : UIViewController {
    
    @IBOutlet var details: UITextView?
    
    internal func requestDataForId(id:String) -> Void {
        
        
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
                
                    self.details?.text = firstName + " " + lastName + "\n\n" + street + " \n" +
                        city + ", " + state + " " + zip + "\n\n" + email + "\n" + telephone
            }
            
        })
        
    }
    
}
