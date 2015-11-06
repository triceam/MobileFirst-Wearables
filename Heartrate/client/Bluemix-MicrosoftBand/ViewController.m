//
//  ViewController.m
//  Bluemix-MicrosoftBand
//
//  Created by Andrew Trice on 10/26/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"

@interface ViewController () <MSBClientManagerDelegate, UITextViewDelegate> {
    NSMutableArray *captureArray;
}
@property (nonatomic, weak) MSBClient *client;
@property (nonatomic, strong) DataManager *dataManager;

@end
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Setup View
    [self markSampleReady:NO];
    self.txtOutput.delegate = self;
    UIEdgeInsets insets = [self.txtOutput textContainerInset];
    insets.top = 20;
    insets.bottom = 20;
    [self.txtOutput setTextContainerInset:insets];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"ReplicationStart"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"ReplicationStatus"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"ReplicationError"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"ReplicationComplete"
                                               object:nil];
    
    [self output:@"Setting up local datastore with replication..."];
    self.dataManager = [DataManager sharedInstance];
    
    
    
    // Setup Band
    [MSBClientManager sharedManager].delegate = self;
    NSArray	*clients = [[MSBClientManager sharedManager] attachedClients];
    self.client = [clients firstObject];
    if (self.client == nil)
    {
        [self output:@"Failed! No Bands attached."];
        return;
    }
    
    [[MSBClientManager sharedManager] connectClient:self.client];
    [self output:[NSString stringWithFormat:@"Please wait. Connecting to Band <%@>", self.client.name]];
    
}


-(void) receiveNotification:(NSNotification *) notification {
    
    NSString *message;
    if ([[notification name] isEqualToString:@"ReplicationStart"]) {
        
        message = @"Replication Started";
    }
    else if ([[notification name] isEqualToString:@"ReplicationComplete"]) {
        
        message = @"Replication Complete";
    }
    else if ([[notification name] isEqualToString:@"ReplicationStatus"]) {
        
        NSDictionary *userInfo = notification.userInfo;
        message = [NSString stringWithFormat:@"Replication %@", [userInfo valueForKey:@"status"] ];
    }
    else {
        
        message = @"Replication Error";
    }
    [self output:message];
}

- (IBAction)didTapStartHRSensorButton:(id)sender
{
    [self markSampleReady:NO];
    if ([self.client.sensorManager heartRateUserConsent] == MSBUserConsentGranted)
    {
        [self startHearRateUpdates];
    }
    else
    {
        [self output:@"Requesting user consent for accessing HeartRate..."];
        __weak typeof(self) weakSelf = self;
        [self.client.sensorManager requestHRUserConsentWithCompletion:^(BOOL userConsent, NSError *error) {
            if (userConsent)
            {
                [weakSelf startHearRateUpdates];
            }
            else
            {
                [weakSelf sampleDidCompleteWithOutput:@"User consent declined."];
            }
        }];
    }
}

- (void)startHearRateUpdates
{
    [self output:@"Starting Heart Rate updates..."];
    captureArray = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    void (^handler)(MSBSensorHeartRateData *, NSError *) = ^(MSBSensorHeartRateData *heartRateData, NSError *error) {
        weakSelf.hrLabel.text = [NSString stringWithFormat:@"Heart Rate: %3u %@",
                                 (unsigned int)heartRateData.heartRate,
                                 heartRateData.quality == MSBSensorHeartRateQualityAcquiring ? @"Acquiring" : @"Locked"];
        NSLog(@"%@", heartRateData);
        
        if ( heartRateData.quality == MSBSensorHeartRateQualityLocked && captureArray != nil) {
            NSDictionary *data = @{
                                   @"sequence":[NSString stringWithFormat: @"%ld", (long)[captureArray count]],
                                   @"heartRate":[NSString stringWithFormat: @"%ld", (long)heartRateData.heartRate]
                                   };
            [captureArray addObject:data];
        }
    };
    
    NSError *stateError;
    if (![self.client.sensorManager startHeartRateUpdatesToQueue:nil errorRef:&stateError withHandler:handler])
    {
        [self sampleDidCompleteWithOutput:stateError.description];
        return;
    }
    
    [self performSelector:@selector(stopHeartRateUpdates) withObject:nil afterDelay:45];
}

- (void)stopHeartRateUpdates
{
    [self.client.sensorManager stopHeartRateUpdatesErrorRef:nil];
    [self sampleDidCompleteWithOutput:@"Heart Rate updates stopped..."];
}

#pragma mark - Helper methods

- (void)sampleDidCompleteWithOutput:(NSString *)output
{
    [self output:output];
    [self markSampleReady:YES];
    if (captureArray != nil &&
        [captureArray count] > 0) {
        
        [self.dataManager saveCapture:captureArray];
        captureArray = nil;
    }
}

- (void)markSampleReady:(BOOL)ready
{
    self.startHRSensorButton.enabled = ready;
    self.startHRSensorButton.alpha = ready ? 1.0 : 0.2;
}

- (void)output:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // do work here

        if (message)
        {
            self.txtOutput.text = [NSString stringWithFormat:@"%@\n%@", self.txtOutput.text, message];
            [self.txtOutput layoutIfNeeded];
            if (self.txtOutput.text.length > 0)
            {
                [self.txtOutput scrollRangeToVisible:NSMakeRange(self.txtOutput.text.length - 1, 1)];
            }
        }
    });
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

#pragma mark - MSBClientManagerDelegate

- (void)clientManager:(MSBClientManager *)clientManager clientDidConnect:(MSBClient *)client
{
    [self markSampleReady:YES];
    [self output:[NSString stringWithFormat:@"Band <%@> connected.", client.name]];
}

- (void)clientManager:(MSBClientManager *)clientManager clientDidDisconnect:(MSBClient *)client
{
    [self markSampleReady:NO];
    [self output:[NSString stringWithFormat:@"Band <%@> disconnected.", client.name]];
}

- (void)clientManager:(MSBClientManager *)clientManager client:(MSBClient *)client didFailToConnectWithError:(NSError *)error
{
    [self output:[NSString stringWithFormat:@"Failed to connect to Band <%@>.", client.name]];
    [self output:error.description];
}

@end
