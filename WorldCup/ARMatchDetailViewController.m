//
//  ARMatchDetailViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 4/28/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARMatchDetailViewController.h"
#import "ARWebViewController.h"

@interface ARMatchDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *teamOneButton;
@property (weak, nonatomic) IBOutlet UIButton *teamTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *yourMatchTimeButton;
@property (nonatomic, strong) IBOutlet UIDatePicker *popUpDatePicker;
@property (nonatomic, strong) IBOutlet UIButton *setReminderButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelReminderButton;
@property (weak, nonatomic) IBOutlet UILabel *daysToGoLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursToGoLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesToGoLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsToGoLabel;

@property (nonatomic, strong) NSString *teamURL;

@end

@implementation ARMatchDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = _match.matchString;
    
    [self setUpTeamFlags];
    [self findMatchTime];
    
    [self updateTimer];
    
    [self setUpReminderButton];
    [self setUpDatePicker];
    [self setUpCancelButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSTimer *timer = [NSTimer new];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

#pragma mark - Reminder methods

- (void)setUpReminderButton
{
    _setReminderButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44)];
    [_setReminderButton setTitle:@"Set reminder" forState:UIControlStateNormal];
    [_setReminderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _setReminderButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _setReminderButton.backgroundColor = [UIColor whiteColor];
    [_setReminderButton addTarget:self action:@selector(setReminder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_setReminderButton];
}

- (void)setUpDatePicker
{
    _popUpDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 80)];
    _popUpDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _popUpDatePicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_popUpDatePicker];
    
    NSDate *dateFromString = [NSDate new];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mma"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/Sao_Paulo"]];
    dateFromString = [dateFormatter dateFromString:_match.matchTime];
    _popUpDatePicker.date = dateFromString;
}

- (void)setUpCancelButton
{
    _cancelReminderButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44)];
    [_cancelReminderButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelReminderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cancelReminderButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _cancelReminderButton.backgroundColor = [UIColor whiteColor];
    [_cancelReminderButton addTarget:self action:@selector(cancelReminder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelReminderButton];
}

- (IBAction)addReminder:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        [_setReminderButton setFrame:CGRectMake(0, self.view.frame.size.height/2 - 10, self.view.frame.size.width, 44)];
        [_popUpDatePicker setFrame:CGRectMake(0, self.view.frame.size.height/2 + 34, self.view.frame.size.width, 80)];
        [_cancelReminderButton setFrame:CGRectMake(0, self.view.frame.size.height/2 + 195, self.view.frame.size.width, 44)];
    }];
}

- (IBAction)setReminder:(id)sender
{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.fireDate = _popUpDatePicker.date;
    localNotification.alertBody = [NSString stringWithFormat:@"Match Reminder: %@", _match.matchString];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    [UIView animateWithDuration:0.25 animations:^{
        [_setReminderButton setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44)];
        [_popUpDatePicker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 80)];
        [_cancelReminderButton setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44)];
    }];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy hh:mma"];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSString *stringFromDate = [dateFormatter stringFromDate:_popUpDatePicker.date];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder Set"
                                                    message:[NSString stringWithFormat:@"%@", stringFromDate]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)cancelReminder:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        [_setReminderButton setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44)];
        [_popUpDatePicker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 100)];
        [_cancelReminderButton setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44)];
        
        NSDate *dateFromString = [NSDate new];
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mma"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/Sao_Paulo"]];
        dateFromString = [dateFormatter dateFromString:_match.matchTime];
        _popUpDatePicker.date = dateFromString;
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showHomeWebView"]) {
        _teamURL = [self retrieveTeamURL:_match.homeTeamName];
        ARWebViewController *wvc = (ARWebViewController *)segue.destinationViewController;
        wvc.teamURL = _teamURL;
    } else if ([segue.identifier isEqualToString:@"showAwayWebView"]) {
        _teamURL = [self retrieveTeamURL:_match.awayTeamName];
        ARWebViewController *wvc = (ARWebViewController *)segue.destinationViewController;
        wvc.teamURL = _teamURL;
    }
}

#pragma mark - Helper methods

- (void)setUpTeamFlags
{
    UIImage *teamOneImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", _match.homeTeamName]];
    _teamOneButton.layer.cornerRadius = _teamOneButton.imageView.image.size.width / 4;
    _teamOneButton.layer.masksToBounds = YES;
    _teamOneButton.clipsToBounds = YES;
    [_teamOneButton setImage:teamOneImage forState:UIControlStateNormal];
    
    UIImage *teamTwoImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", _match.awayTeamName]];
    _teamTwoButton.layer.cornerRadius = _teamTwoButton.imageView.image.size.width / 4;
    _teamTwoButton.layer.masksToBounds = YES;
    _teamTwoButton.clipsToBounds = YES;
    [_teamTwoButton setImage:teamTwoImage forState:UIControlStateNormal];
}

- (void)findMatchTime
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mma"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/Sao_Paulo"]];
    NSDate *dateFromString = [dateFormatter dateFromString:_match.matchTime];

    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MMMM dd h:mma"];
    NSString *stringFromDate = [formatter stringFromDate:dateFromString];
    
    [_yourMatchTimeButton setTitle:stringFromDate forState:UIControlStateNormal];
}

- (NSString *)retrieveTeamURL:(NSString *)teamName
{
    NSDictionary *codeURLDictionary = @{@"Brazil"               :@"43924",
                                        @"Croatia"              :@"43938",
                                        @"Mexico"               :@"43911",
                                        @"Cameroon"             :@"43849",
                                        @"Spain"                :@"43969",
                                        @"Netherlands"          :@"43960",
                                        @"Chile"                :@"43925",
                                        @"Australia"            :@"43976",
                                        @"Colombia"             :@"43926",
                                        @"Greece"               :@"43949",
                                        @"Ivory Coast"          :@"43854",
                                        @"Japan"                :@"43819",
                                        @"Uruguay"              :@"43930",
                                        @"Costa Rica"           :@"43901",
                                        @"England"              :@"43942",
                                        @"Italy"                :@"43954",
                                        @"Switzerland"          :@"43971",
                                        @"Ecuador"              :@"43927",
                                        @"France"               :@"43946",
                                        @"Honduras"             :@"43909",
                                        @"Argentina"            :@"43922",
                                        @"Bosnia Herzegovina"   :@"44037",
                                        @"Iran"                 :@"43817",
                                        @"Nigeria"              :@"43876",
                                        @"Germany"              :@"43948",
                                        @"Portugal"             :@"43963",
                                        @"Ghana"                :@"43860",
                                        @"USA"                  :@"43921",
                                        @"Belgium"              :@"43935",
                                        @"Algeria"              :@"43843",
                                        @"Russia"               :@"43965",
                                        @"Korea Republic"       :@"43822"};
    
    NSString *tempTeamURL = [NSString stringWithFormat:@"http://m.fifa.com/worldcup/teams/team=%@", [codeURLDictionary objectForKey:teamName]];
    return tempTeamURL;
}

- (void)updateTimer
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"America/Sao_Paulo"]];
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mma"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/Sao_Paulo"]];
    NSDate *dateFromString = [dateFormatter dateFromString:_match.matchTime];
    
    if ([now compare:dateFromString] == NSOrderedAscending)
    {   // now is earlier than match time
        NSDateComponents *componentsDays = [calendar components:NSDayCalendarUnit
                                                       fromDate:now
                                                         toDate:dateFromString
                                                        options:0];
        _daysToGoLabel.text = [NSString stringWithFormat:@"%02ld", (long)(componentsDays.day)];
        NSDateComponents *componentsHours = [calendar components:NSHourCalendarUnit
                                                        fromDate:now
                                                          toDate:dateFromString
                                                         options:0];
        _hoursToGoLabel.text = [NSString stringWithFormat:@"%02ld", (long)(componentsHours.hour%24)];
        NSDateComponents *componentsMinutes = [calendar components:NSMinuteCalendarUnit
                                                          fromDate:now
                                                            toDate:dateFromString
                                                           options:0];
        _minutesToGoLabel.text = [NSString stringWithFormat:@"%02ld", (long)(componentsMinutes.minute%60)];
        NSDateComponents *componentsSeconds = [calendar components:NSSecondCalendarUnit
                                                          fromDate:now
                                                            toDate:dateFromString
                                                           options:0];
        _secondsToGoLabel.text = [NSString stringWithFormat:@"%02ld", (long)(componentsSeconds.second%60)];
    } else {
        _daysToGoLabel.text = @"00";
        _hoursToGoLabel.text = @"00";
        _minutesToGoLabel.text = @"00";
        _secondsToGoLabel.text = @"00";
    }
}

@end
