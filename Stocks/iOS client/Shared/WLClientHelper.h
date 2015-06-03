//
//  WLClientEnhanced.h
//  Stocks
//
//  Created by Andrew Trice on 5/29/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLClient.h"
#import "OCLogger.h"
#import "WLResponse.h"
#import "WLFailResponse.h"

@interface WLClientHelper : NSObject


+(void) invokeProcedure:(WLProcedureInvocationData *)invocationData successCallback:(void (^)(WLResponse*))success errorCallback:(void (^)(WLFailResponse*))error;

+(OCLogger*) getLoggerForInstance:(NSObject*)instance;

@end
