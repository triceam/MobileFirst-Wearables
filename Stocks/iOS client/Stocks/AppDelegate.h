//
//  AppDelegate.h
//  Stocks
//
//  Created by Andrew Trice on 5/27/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLClient.h"
#import "OCLogger.h"
#import "WLDelegate.h"
#import "WLClientHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WLDelegate> {
    
    OCLogger *logger;
}

@property (strong, nonatomic) UIWindow *window;


@end

