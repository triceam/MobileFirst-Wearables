//
//  WLClientEnhanced.m
//  Stocks
//
//  Created by Andrew Trice on 5/29/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

#import "WLClientHelper.h"


/********************************************************
 Private Delegate instance used by WLClientHelper
********************************************************/

@interface DataRequestDelegate : NSObject <WLDelegate>
@property (copy) void (^successCallback)(WLResponse*);
@property (copy) void (^errorCallback)(WLFailResponse*);


-(id)initWithSuccess:(void (^)(WLResponse*))success error:(void (^)(WLFailResponse*))error;
-(void) cleanup;
@end



@implementation DataRequestDelegate


-(id)initWithSuccess:(void (^)(WLResponse*))success error:(void (^)(WLFailResponse*))error{
    
    self = [super init];
    
    self.successCallback = success;
    self.errorCallback = error;
    
    return self;
}


-(void)cleanup {
    
    self.successCallback = nil;
    self.errorCallback = nil;
}


-(void)onSuccess:(WLResponse *)response {
    
    if ( self.successCallback != nil ) {
        self.successCallback(response);
    }
    [self cleanup];
}

-(void)onFailure:(WLFailResponse *)response {
    
    if ( self.errorCallback != nil ) {
        self.errorCallback(response);
    }
    [self cleanup];
}


@end











/********************************************************
 Public static helper methods
********************************************************/

@implementation WLClientHelper


/*
 invoke a MobileFirst/Worklight procedue using the completionHandler pattern instead of using custom delegates
 */
+(void) invokeProcedure:(WLProcedureInvocationData *)invocationData successCallback:(void (^)(WLResponse*))success errorCallback:(void (^)(WLFailResponse*))error {
    
    
    DataRequestDelegate *delegate = [[DataRequestDelegate alloc] initWithSuccess:success error:error];
    [[WLClient sharedInstance] invokeProcedure:invocationData withDelegate:delegate];
}


/*
 get a logger with the package name from the instance class name
 */
+(OCLogger*) getLoggerForInstance:(NSObject*)instance {
    
    NSString *packageName = NSStringFromClass([instance class]);
    OCLogger *logger = [OCLogger getInstanceWithPackage:packageName];
    return logger;
}

@end








