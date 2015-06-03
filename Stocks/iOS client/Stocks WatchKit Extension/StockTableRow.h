//
//  StockTableRow.h
//  Stocks
//
//  Created by Andrew Trice on 5/28/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface StockTableRow : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceLabel* stockLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* priceLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel* changeLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup* containerGroup;


@end
