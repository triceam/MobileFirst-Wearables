//
//  DataManager.m
//  heartmonitor
//
//  Created by Andrew Trice on 3/13/15.
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
    
    if ( self ) {
        logger = [IMFLogger loggerForName:NSStringFromClass([self class])];
        [logger logDebugWithMessages:@"initializing local datastore ..."];
        
        // initialize an instance of the IMFDataManager
        self.manager = [IMFDataManager sharedInstance];

        NSError *error = nil;
        self.datastore = [self.manager localStore:@"heartmonitor" error:&error];

        if (error) {
            [logger logErrorWithMessages:@"Error creating local data store %@",error.description];
        }

        //create a remote data store
        [self.manager remoteStore:@"heartmonitor" completionHandler:^(CDTStore *store, NSError *error) {
            if (error) {
                [logger logErrorWithMessages:@"Error creating remote data store %@",error.description];
            } else {
                [self.manager setCurrentUserPermissions:DB_ACCESS_GROUP_MEMBERS forStoreName:@"heartmonitor" completionHander:^(BOOL success, NSError *error) {
                    if (error) {
                        [logger logErrorWithMessages:@"Error setting permissions for user with error %@",error.description];
                    }
                    
                    [self replicate];
                }];
            }
        }];
        
        
        // for testing if data was actually saved
        //[self getLocalData];
        
        [self replicate];
    }
    
    return self;
}



-(void) saveCapture:(NSArray*)data {
    
    [logger logDebugWithMessages:@"saveImage withLocation"];
    
    //save in background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
       
        [logger logDebugWithMessages:@"creating document..."];
        
        NSDate *now = [NSDate date];
        NSString *dateString = [NSDateFormatter localizedStringFromDate:now
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterFullStyle];

        // Create a document
        CDTMutableDocumentRevision *rev = [CDTMutableDocumentRevision revision];
        rev.body = @{
                     @"sort": [NSNumber numberWithDouble:[now timeIntervalSince1970]],
                     @"clientDate": dateString,
                     @"data": data,
                     @"type": @"com.heartmonitor.entry"
                     };
        
        
        //save the attachment to local storage
        [self.datastore save:rev completionHandler:^(id savedObject, NSError *error) {
            if(error) {
                [logger logErrorWithMessages:@"Error creating document: %@", error.localizedDescription];
            }
            [logger logDebugWithMessages:@"Document created: %@", savedObject];
        }];
        
        [self replicate];
    });
}



-(void) replicate {
    
    if ( self.replicator == nil ) {
        [logger logDebugWithMessages:@"attempting replication to remote datastore..."];
        
        __block NSError *replicationError;
        CDTPushReplication *push = [self.manager pushReplicationForStore: @"heartmonitor"];
        self.replicator = [self.manager.replicatorFactory oneWay:push error:&replicationError];
        if(replicationError){
            // Handle error
            [logger logErrorWithMessages:@"An error occurred: %@", replicationError.localizedDescription];
        }
        
        self.replicator.delegate = self;
        
        replicationError = nil;
        [logger logDebugWithMessages:@"starting replication"];
        [self.replicator startWithError:&replicationError];
        if(replicationError){
            [logger logErrorWithMessages:@"An error occurred: %@", replicationError.localizedDescription];
        }else{
            [logger logDebugWithMessages:@"replication start successful"];
        }
    }
    else {
        [logger logDebugWithMessages:@"replicator already running"];
    }
}


- (void)replicatorDidChangeState:(CDTReplicator *)replicator {
    [logger logDebugWithMessages:@"Replicator changed State: %@", [CDTReplicator stringForReplicatorState:replicator.state]];
}

- (void)replicatorDidChangeProgress:(CDTReplicator *)replicator {
    [logger logDebugWithMessages:@"Replicator progress: %d/%d", replicator.changesProcessed, replicator.changesTotal];
    
    NSDictionary *userInfo = @{ @"status":[NSString stringWithFormat:@"%d/%d", replicator.changesProcessed, replicator.changesTotal] };
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReplicationStatus"
     object:self
     userInfo:userInfo];
}

- (void)replicatorDidError:(CDTReplicator *)replicator info:(NSError *)info {
    [logger logErrorWithMessages:@"An error occurred: %@", info.localizedDescription];
    self.replicator = nil;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReplicationError"
     object:self];
}

- (void)replicatorDidComplete:(CDTReplicator *)replicator {
    [logger logDebugWithMessages:@"Replication completed"];
    self.replicator = nil;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReplicationComplete"
     object:self];
}


@end
