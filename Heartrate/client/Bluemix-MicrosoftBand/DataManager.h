//
//  DataManager.h
//  GeoPix
//
//  Created by Andrew Trice on 3/13/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IMFCore/IMFCore.h>
#import <IMFData/IMFData.h>
#import <CloudantToolkit/CloudantToolkit.h>
#import <CloudantSync.h>
#import <CoreLocation/CoreLocation.h>
#import "CDTDatastore+Query.h"
#import "CDTQResultSet.h"


@interface DataManager : NSObject <CDTReplicatorDelegate> {
    
    IMFLogger *logger;
}

@property (nonatomic, strong) IMFDataManager *manager;
@property (nonatomic, strong) CDTStore *datastore;
@property (nonatomic, strong) CDTReplicator *replicator;


+(id) sharedInstance;

-(void) saveCapture:(NSArray*)array;

@end
