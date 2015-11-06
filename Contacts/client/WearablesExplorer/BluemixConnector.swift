//
//  BluemixConnector.swift
//  WearablesExplorer
//
//  Created by Andrew Trice on 10/22/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

import Foundation
import IMFCore

class BluemixConnector {
    
    
    var logger:IMFLogger?
    
    func connect(target:String!) -> Void {
        
        
        IMFLogger.setLogLevel(IMFLogLevel.Info);
        IMFLogger.captureUncaughtExceptions();
        IMFAnalytics.sharedInstance().startRecordingApplicationLifecycleEvents();
        
        logger = IMFLogger(forName: "BMC:" + target!);
        logger!.logInfoWithMessages("connecting to bluemix...");
        
        IMFClient.sharedInstance().initializeWithBackendRoute("http://yourapp.mybluemix.net", backendGUID: "Your GUID goes here");
        
        self.verifyConnection();
        
    }
    
    
    
    func verifyConnection() {
        
        let authManager:IMFAuthorizationManager = IMFAuthorizationManager.sharedInstance();
        
        authManager.obtainAuthorizationHeaderWithCompletionHandler { (response:IMFResponse!, error:NSError!) -> Void in
            if (error == nil) {
                self.logger!.logInfoWithMessages("connected to bluemix");
            }
            else {
                self.logger!.logErrorWithMessages(error.localizedDescription);
            }
        }
    }
    
    func sendLogs() -> Void {
        
        IMFLogger.send();
        IMFAnalytics.sharedInstance().sendPersistedLogs();
    }
}