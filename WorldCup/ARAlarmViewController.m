//
//  ARAlarmViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 5/2/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARAlarmViewController.h"

@interface ARAlarmViewController ()


@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation ARAlarmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _datePicker.date = _matchTime;
}

- (IBAction)setReminder:(id)sender
{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:15];
    localNotification.alertBody = @"Your alert message";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

    
}

@end
