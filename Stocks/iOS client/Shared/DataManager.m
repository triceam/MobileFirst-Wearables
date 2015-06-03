//
//  DataManager.m
//  Stocks
//
//  Created by Andrew Trice on 5/27/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager



+(DataManager*) sharedInstance {
    
    static DataManager *instance = nil;
    DataManager *strongInstance = instance;
    
    @synchronized(self) {
        if (strongInstance == nil) {
            strongInstance = [[[self class] alloc] init];
            instance = strongInstance;
        }
    }
    
    return strongInstance;
}

-(id) init {
    
    self = [super init];
    
    logger = [WLClientHelper getLoggerForInstance:self];
    
    return self;
}


-(void) getList:(void (^)(NSArray*))callback{
    
    WLProcedureInvocationData *invocationData =
        [[WLProcedureInvocationData alloc]
            initWithAdapterName:@"StockAdapter"
                  procedureName:@"getList"];
        
    [WLClientHelper invokeProcedure:invocationData successCallback:^(WLResponse *successResponse) {
        
        NSArray *responseData = [[successResponse responseJSON] objectForKey:@"stocks"];
        //handle the response
        callback(responseData);
        

    } errorCallback:^(WLFailResponse *errorResponse) {
        
        //you should do better error handling than this
        callback(nil);
    }];
}


-(void) getDetailForStock:(NSDictionary*)stock with:(void (^)(NSDictionary*))callback{
    
    WLProcedureInvocationData *invocationData = [[WLProcedureInvocationData alloc] initWithAdapterName:@"StockAdapter" procedureName:@"getDetail"];
    
    invocationData.parameters = @[[stock objectForKey:@"symbol"]];
    
    [WLClientHelper invokeProcedure:invocationData successCallback:^(WLResponse *successResponse) {
        
        NSDictionary *responseData = [successResponse responseJSON];
        callback(responseData);
        
    } errorCallback:^(WLFailResponse *errorResponse) {
        
        //you should do better error handling than this
        callback(nil);
    }];
    
}



@end
