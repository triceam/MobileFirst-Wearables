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
    
    NSURL* url = [NSURL URLWithString:@"/adapters/StockAdapter/getList"];
    WLResourceRequest* request = [WLResourceRequest requestWithURL:url method:WLHttpMethodGet];
    
    [request sendWithCompletionHandler:^(WLResponse *response, NSError *error) {
        if(error != nil){
            //you should do better error handling than this
            callback(nil);
        }
        else{
            NSDictionary *responseJSON = response.responseJSON;
            callback( [responseJSON objectForKey:@"stocks"] );
        }
    }];
}


-(void) getDetailForStock:(NSDictionary*)stock with:(void (^)(NSDictionary*))callback{
    
    
    NSURL* url = [NSURL URLWithString:@"/adapters/StockAdapter/getDetail"];
    WLResourceRequest* request = [WLResourceRequest requestWithURL:url method:WLHttpMethodGet];
    
    NSString *paramsString = [NSString stringWithFormat:@"['%@']", [stock objectForKey:@"symbol"]];
    
    [request setQueryParameterValue:paramsString forName:@"params"];
    
    [request sendWithCompletionHandler:^(WLResponse *response, NSError *error) {
        if(error != nil){
            //you should do better error handling than this
            callback(nil);
        }
        else{
            NSDictionary *responseJSON = response.responseJSON;
            callback( responseJSON );
        }
    }];}



@end
