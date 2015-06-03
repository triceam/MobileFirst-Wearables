//
//  DataManager.h
//  Stocks
//
//  Created by Andrew Trice on 5/27/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLResponse.h"
#import "WLProcedureInvocationData.h"
#import "WLClient.h"
#import "OCLogger.h"
#import "WLClientHelper.h"

@interface DataManager : NSObject {
    
    OCLogger *logger;
}



+(id) sharedInstance;

-(void) getList:(void (^)(NSArray*))callback;
-(void) getDetailForStock:(NSDictionary*)stock with:(void (^)(NSDictionary*))callback;

@end
