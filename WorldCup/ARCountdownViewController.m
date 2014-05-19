//
//  ARCountdownViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 4/29/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARCountdownViewController.h"

@interface ARCountdownViewController ()

@property (weak, nonatomic) IBOutlet UILabel *daysToGoLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursToGoLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesToGoLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsToGoLabel;
@property (weak, nonatomic) IBOutlet UILabel *untilLabel;

@end

@implementation ARCountdownViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSTimer *timer = [NSTimer new];
    timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(bounceCountdownViewController) userInfo:nil repeats:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSTimer *timer = [NSTimer new];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)bounceCountdownViewController
{
    [UIView animateWithDuration:0.4 animations:^{
        self.view.center = CGPointMake(self.view.center.x + self.view.frame.size.width / 5, self.view.center.y);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.4 animations:^{
                self.view.center = CGPointMake(self.view.center.x - self.view.frame.size.width / 5, self.view.center.y);
            }];
        }
    }];
}

- (void)updateTimer
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];

    NSDateComponents *kickOffComponents = [NSDateComponents new];
    [kickOffComponents setYear:2014];
    [kickOffComponents setMonth:6];
    [kickOffComponents setDay:12];
    [kickOffComponents setHour:13];
    [kickOffComponents setMinute:0];
    [kickOffComponents setSecond:0];
    NSDate *kickOffDate = [calendar dateFromComponents:kickOffComponents];
    
    NSDateComponents *finalMatchComponents = [NSDateComponents new];
    [finalMatchComponents setYear:2014];
    [finalMatchComponents setMonth:7];
    [finalMatchComponents setDay:13];
    [finalMatchComponents setHour:12];
    [finalMatchComponents setMinute:0];
    [finalMatchComponents setSecond:0];
    NSDate *finalMatchDate = [calendar dateFromComponents:finalMatchComponents];
    
    if ([now compare:kickOffDate] == NSOrderedAscending)
    {   // now is earlier than kickOffDate
        NSDateComponents *componentsDays = [calendar components:NSDayCalendarUnit
                                                       fromDate:now
                                                         toDate:kickOffDate
                                                        options:0];
        _daysToGoLabel.text = [NSString stringWithFormat:@"%02ld", (long)(componentsDays.day)];
        NSDateComponents *componentsHours = [calendar components:NSHourCalendarUnit
                                                        fromDate:now
                                                          toDate:kickOffDate
                                                         options:0];
        _hoursToGoLabel.text = [NSString stringWithFormat:@"%02ld", (componentsHours.hour%24)];
        NSDateComponents *componentsMinutes = [calendar components:NSMinuteCalendarUnit
                                                          fromDate:now
                                                            toDate:kickOffDate
                                                           options:0];
        _minutesToGoLabel.text = [NSString stringWithFormat:@"%02ld", (componentsMinutes.minute%60)];
        NSDateComponents *componentsSeconds = [calendar components:NSSecondCalendarUnit
                                                          fromDate:now
                                                            toDate:kickOffDate
                                                           options:0];
        _secondsToGoLabel.text = [NSString stringWithFormat:@"%02ld", (componentsSeconds.second%60)];
        
        _untilLabel.text = @"to first match";
        
    } else if (([now compare:kickOffDate] == NSOrderedDescending) && ([now compare:finalMatchDate] == NSOrderedAscending))
    {   // now is later than kickOffDate and before finalMatchDate
        NSDateComponents *componentsDays = [calendar components:NSDayCalendarUnit
                                                       fromDate:now
                                                         toDate:finalMatchDate
                                                        options:0];
        _daysToGoLabel.text = [NSString stringWithFormat:@"%02ld", (long)(componentsDays.day)];
        NSDateComponents *componentsHours = [calendar components:NSHourCalendarUnit
                                                        fromDate:now
                                                          toDate:finalMatchDate
                                                         options:0];
        _hoursToGoLabel.text = [NSString stringWithFormat:@"%02ld", (componentsHours.hour%24)];
        NSDateComponents *componentsMinutes = [calendar components:NSMinuteCalendarUnit
                                                          fromDate:now
                                                            toDate:finalMatchDate
                                                           options:0];
        _minutesToGoLabel.text = [NSString stringWithFormat:@"%02ld", (componentsMinutes.minute%60)];
        NSDateComponents *componentsSeconds = [calendar components:NSSecondCalendarUnit
                                                          fromDate:now
                                                            toDate:finalMatchDate
                                                           options:0];
        _secondsToGoLabel.text = [NSString stringWithFormat:@"%02ld", (componentsSeconds.second%60)];
        
        _untilLabel.text = @"to final match";
        
    } else {
        _daysToGoLabel.text = @"00";
        _hoursToGoLabel.text = @"00";
        _minutesToGoLabel.text = @"00";
        _secondsToGoLabel.text = @"00";
        _untilLabel.text = @"";
    }
}

@end
