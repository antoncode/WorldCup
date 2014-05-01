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

@end

@implementation ARCountdownViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSTimer *timer = [NSTimer new];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(bounceCountdownViewController) userInfo:nil repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    NSTimer *timer = [NSTimer new];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)bounceCountdownViewController
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.center.x + self.view.frame.size.width / 5, self.view.center.y);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.75 animations:^{
                self.view.center = CGPointMake(self.view.center.x - self.view.frame.size.width / 5, self.view.center.y);
            }];
        }
    }];
}

- (void)updateTimer
{
    NSString *kickOff = @"06-12-2014 14:00:00";     // Date and time of first match
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    NSDate *dateFromKickOff = [dateFormatter dateFromString:kickOff];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *componentsDays = [gregorianCalendar components:NSDayCalendarUnit
                                                            fromDate:now
                                                              toDate:dateFromKickOff
                                                             options:0];
    NSDateComponents *componentsHours = [calendar components:NSHourCalendarUnit fromDate:now];
    NSDateComponents *componentsMinutes = [calendar components:NSMinuteCalendarUnit fromDate:now];
    NSDateComponents *componentsSeconds = [calendar components:NSSecondCalendarUnit fromDate:now];
    
    _daysToGoLabel.text = [NSString stringWithFormat:@"%ld", (long)(componentsDays.day)];
    _hoursToGoLabel.text = [NSString stringWithFormat:@"%ld", (24-componentsHours.hour)];
    _minutesToGoLabel.text = [NSString stringWithFormat:@"%02ld", (60-componentsMinutes.minute)];
    _secondsToGoLabel.text = [NSString stringWithFormat:@"%02ld", (60-componentsSeconds.second)];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}



@end
