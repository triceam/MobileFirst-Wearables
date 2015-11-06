//
//  DataManager.swift
//  WearablesExplorer
//
//  Created by Andrew Trice on 10/23/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

import Foundation
import IMFCore
import IMFData

class DataManager {
    
    static var instance:DataManager = DataManager()
    
    var logger:IMFLogger?
    
    let listPath:String = "https://yourapp.mybluemix.net/api/Contacts?filter[fields][firstName]=true&filter[fields][id]=true&filter[fields][lastName]=true&filter[order][0]=lastName%20ASC&filter[order][1]firstName]=ASC"
    
    let detailPath:String = "https:/yourapp.mybluemix.net/api/Contacts/"
    
    func getList(completion: (results: [AnyObject]?) -> Void) {
        
        if (logger == nil) {
            self.logger = IMFLogger(forName: "DataManager");
        }
        self.logger!.logInfoWithMessages("requesting top level list data...");
        
        var parameters : [String:String] = [
            "filter[fields][firstName]":"true",
            "filter[fields][lastName]":"true",
            "filter[fields][id]":"true",
            "filter[order][0]":"lastName ASC",
            "filter[order][1]":"firstName ASC"
        ];
        
        var request = IMFResourceRequest(path: self.listPath, method: "GET", parameters: parameters)
        request.sendWithCompletionHandler { (response:IMFResponse!, error:NSError!) -> Void in
            if (error != nil) {
                self.logger?.logErrorWithMessages(error.localizedDescription);
                completion(results: nil);
            }
            else {
                self.logger?.logInfoWithMessages(response.responseText);
                
                var responseString = "{\"results\":" + response.responseText + "}"
                
                let JSONData = response.responseText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                let JSONObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(JSONData!, options: nil, error: nil)
                
                let resultsArray = JSONObject as? [AnyObject];
                
                completion(results: resultsArray);
            }
            
        }
    }
    
    
    func getDetail(id:String, completion: (result: AnyObject?) -> Void) {
        
        let path :String = self.detailPath + id
        
        var request = IMFResourceRequest(path: path, method: "GET")
        request.sendWithCompletionHandler { (response:IMFResponse!, error:NSError!) -> Void in
            if (error != nil) {
                self.logger?.logErrorWithMessages(error.localizedDescription);
                completion(result: nil);
            }
            else {
                self.logger?.logInfoWithMessages(response.responseText);
                
                var responseString = "{\"results\":" + response.responseText + "}"
                
                let JSONData = response.responseText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                let JSONObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(JSONData!, options: nil, error: nil)
                
                completion(result: JSONObject)
            }
            
        }

    }
    
}