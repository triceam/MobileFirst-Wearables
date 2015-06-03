//
//  InterfaceController.h
//  Stocks WatchKit Extension
//
//  Created by Andrew Trice on 5/27/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "WLClient.h"
#import "OCLogger.h"
#import "WLDelegate.h"
#import "DataManager.h"

@interface InterfaceController : WKInterfaceController <WLDelegate> {
    
    OCLogger *logger;
    BOOL connected;
}

@property (weak, nonatomic) IBOutlet WKInterfaceLabel* feedbackLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceTable* dataTable;
@property (strong, nonatomic) NSArray* stocks;

@end
