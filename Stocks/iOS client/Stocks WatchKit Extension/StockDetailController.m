//
//  StockDetailController.m
//  Stocks
//
//  Created by Andrew Trice on 5/28/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

#import "StockDetailController.h"
#import "StockTableRow.h"

@interface StockDetailController ()

@end

@implementation StockDetailController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    NSString *packageName = [NSString stringWithFormat:@"WatchKit:%@", NSStringFromClass([self class])];
    logger = [OCLogger getInstanceWithPackage:packageName];

    NSDictionary *stock = (NSDictionary*)context;
    [logger debug:@"awakeWithContext: %@", stock];
    
    [self setTitle:[stock objectForKey:@"symbol"]];
    
    [[DataManager sharedInstance] getDetailForStock:stock with:^(NSDictionary *stockData) {
        [logger debug:[stockData objectForKey:@"symbol"]];
        
        [self.nameLabel setText:[stockData objectForKey:@"name"]];
        
        NSNumber *change = [stockData objectForKey:@"change"];
        NSNumber *price = [stockData objectForKey:@"price"];
        NSNumber *high = [stockData objectForKey:@"high"];
        NSNumber *low = [stockData objectForKey:@"low"];
        NSNumber *high52 = [stockData objectForKey:@"high52"];
        NSNumber *low52 = [stockData objectForKey:@"low52"];
        NSNumber *open = [stockData objectForKey:@"open"];
        NSNumber *eps = [stockData objectForKey:@"eps"];
        
        float percentChange = [change floatValue]/[price floatValue];
        
        
        [self.priceLabel setText:[NSString stringWithFormat:@"%-.2f", [price floatValue]]];
        [self.changeLabel setText:[NSString stringWithFormat:@"%.02f (%.02f%%)", [change floatValue], percentChange]];
        
        if ([change floatValue] > 0.0) {
            [self.changeLabel setTextColor: [UIColor greenColor]];
        } else if ([change floatValue] < 0.0) {
            [self.changeLabel setTextColor: [UIColor redColor]];
        }
        else {
            [self.changeLabel setTextColor: [UIColor whiteColor]];
        }
        
        //update change with percentage
        
        [self.highLabel setText:[NSString stringWithFormat:@"%-.2f", [high floatValue]]];
        [self.lowLabel setText:[NSString stringWithFormat:@"%-.2f", [low floatValue]]];
        [self.high52Label setText:[NSString stringWithFormat:@"%-.2f", [high52 floatValue]]];
        [self.low52Label setText:[NSString stringWithFormat:@"%-.2f", [low52 floatValue]]];
        
        [self.openLabel setText:[NSString stringWithFormat:@"%-.2f", [open floatValue]]];
        [self.epsLabel setText:[NSString stringWithFormat:@"%-.2f", [eps floatValue]]];
        [self.volLabel setText:[stockData objectForKey:@"shares"]];
    }];
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



