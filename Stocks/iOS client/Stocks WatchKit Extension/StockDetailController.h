//
//  StockDetailController.h
//  Stocks
//
//  Created by Andrew Trice on 5/28/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "OCLogger.h"
#import "DataManager.h"


@interface StockDetailController : WKInterfaceController {
    
    OCLogger *logger;
}

@property (weak, nonatomic) IBOutlet WKInterfaceLabel* nameLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* priceLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* changeLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* highLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* lowLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* high52Label;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* low52Label;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* openLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* epsLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* volLabel;

@end
