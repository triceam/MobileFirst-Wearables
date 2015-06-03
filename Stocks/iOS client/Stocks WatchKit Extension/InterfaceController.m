//
//  InterfaceController.m
//  Stocks WatchKit Extension
//
//  Created by Andrew Trice on 5/27/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

#import "InterfaceController.h"
#import "StockTableRow.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    connected = NO;

    // Configure interface objects here.
    NSString *packageName = [NSString stringWithFormat:@"WatchKit:%@", NSStringFromClass([self class])];
    logger = [OCLogger getInstanceWithPackage:packageName];
    [OCLogger setCapture:YES];
    [OCLogger setAutoSendLogs:YES];
    
    [logger debug:@"didFinishLaunchingWithOptions"];
    
    [[WLClient sharedInstance] wlConnectWithDelegate: self];
    
    [self setTitle:@"MFP Stocks"];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [logger debug:@"willActivate"];
    
    [self refreshData];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
    [logger debug:@"didDeactivate"];
}



-(void)onSuccess:(WLResponse *)response {
    
    [logger debug:@"WL Connection SUCCESS"];
    connected = YES;
    
    [self refreshData];
}

-(void)onFailure:(WLFailResponse *)response {
    
    [logger debug:@"WL Connection FAIL"];
    [logger debug:response.description];
}


-(void) refreshData {
    
    
    if (connected) {
        //display the loading message, if you want it... UX needs refinement
        //[self.feedbackLabel setHidden:NO];
        
        //request the list data
        [[DataManager sharedInstance] getList:^(NSArray *results) {
            if (results != nil) {
                self.stocks = results;
                [self buildUI];
            }
        }];
    }
}

-(void) buildUI {
    
    [self.feedbackLabel setHidden:YES];
    [self.dataTable setNumberOfRows:[self.stocks count] withRowType:@"stockTableRow"];
    
    for (NSInteger i = 0; i < self.dataTable.numberOfRows; i++) {
        
        StockTableRow* row = [self.dataTable rowControllerAtIndex:i];
        NSDictionary* item = [self.stocks objectAtIndex:i];
        
        [row.stockLabel setText:[item valueForKey:@"symbol"]];
        
        NSNumber *price = [item valueForKey:@"price"];
        NSNumber *change = [item valueForKey:@"change"];
        [row.priceLabel setText:[NSString stringWithFormat:@"%-.2f", [price floatValue]]];
        [row.changeLabel setText:[NSString stringWithFormat:@"%-.2f", [change floatValue]]];
        
        if ([change floatValue] > 0.0) {
            [row.changeLabel setTextColor: [UIColor greenColor]];
            [row.containerGroup setBackgroundColor:[UIColor colorWithRed:0 green:0.2 blue:0 alpha:1]];
        } else if ([change floatValue] < 0.0) {
            [row.changeLabel setTextColor: [UIColor redColor]];
            [row.containerGroup setBackgroundColor:[UIColor colorWithRed:0.2 green:0 blue:0 alpha:1]];
        }
        else {
            [row.changeLabel setTextColor: [UIColor whiteColor]];
            [row.containerGroup setBackgroundColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1]];
        }
    }
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier
                            inTable:(WKInterfaceTable *)table
                           rowIndex:(NSInteger)rowIndex {
    
    NSDictionary* stock = [self.stocks objectAtIndex:rowIndex];
    
    return stock;
}

@end



