//
//  ViewController.h
//  Bluemix-MicrosoftBand
//
//  Created by Andrew Trice on 10/26/15.
//  Copyright (c) 2015 Andrew Trice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MicrosoftBandKit_iOS/MicrosoftBandKit_iOS.h>

@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextView *txtOutput;
@property (weak, nonatomic) IBOutlet UILabel *hrLabel;
@property (weak, nonatomic) IBOutlet UIButton *startHRSensorButton;

- (IBAction)didTapStartHRSensorButton:(id)sender;

@end

