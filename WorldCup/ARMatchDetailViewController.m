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

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) NSDate *dateFromString1, *dateFromString2;
@property (weak, nonatomic) IBOutlet UIButton *teamOneButton;
@property (weak, nonatomic) IBOutlet UIButton *teamTwoButton;
@property (weak, nonatomic) IBOutlet UIImageView *teamOneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *teamTwoImageView;
@property (weak, nonatomic) IBOutlet UIButton *yourMatchTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *brazilMatchTimeButton;
@property (nonatomic, strong) IBOutlet UIDatePicker *popUpDatePicker;
@property (nonatomic, strong) IBOutlet UIButton *setReminderButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelReminderButton;
@property (nonatomic, strong) NSString *teamURL;

@end

@implementation ARMatchDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = _match.matchString;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.opaque = NO;

    
    [self setUpTeamFlags];
    [self findMatchTime];
    [self printMatchTime];
    
    [self setUpReminderButton];
    [self setUpDatePicker];
    [self setUpCancelButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpTeamFlags];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    
    [self.view removeGestureRecognizer:_panRecognizer];
}

#pragma mark - Reminder methods

- (void)setUpReminderButton
{
    // Set up reminder button
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
    // Set up date picker
    _popUpDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 80)];
    _popUpDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _popUpDatePicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_popUpDatePicker];
    
    // Set date picker date
    NSDate *dateFromString = [NSDate new];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mma"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/Sao_Paulo"]];
    dateFromString = [dateFormatter dateFromString:_match.matchTime];
    _popUpDatePicker.date = dateFromString;
}

- (void)setUpCancelButton
{
    // Set up cancel button
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
    // Show date picker
    [UIView animateWithDuration:0.25 animations:^{
        [_setReminderButton setFrame:CGRectMake(0, self.view.frame.size.height/2 - 10, self.view.frame.size.width, 44)];
        [_popUpDatePicker setFrame:CGRectMake(0, self.view.frame.size.height/2 + 35, self.view.frame.size.width, 80)];
        [_cancelReminderButton setFrame:CGRectMake(0, self.view.frame.size.height/2 + 198, self.view.frame.size.width, 44)];
    }];
}

- (IBAction)setReminder:(id)sender
{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.fireDate = _popUpDatePicker.date;
    localNotification.alertBody = [NSString stringWithFormat:@"%@ beggining soon!", _match.matchString];
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
    }];
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
    NSDateFormatter *dateFormatter1 = [NSDateFormatter new];
    [dateFormatter1 setDateFormat:@"MM-dd-yyyy hh:mma"];
    [dateFormatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"America/Sao_Paulo"]];
    _dateFromString1 = [dateFormatter1 dateFromString:_match.matchTime];
    
    NSDateFormatter *dateFormatter2 = [NSDateFormatter new];
    [dateFormatter2 setDateFormat:@"MM-dd-yyyy hh:mma"];
    [dateFormatter2 setTimeZone:[NSTimeZone defaultTimeZone]];
    _dateFromString2 = [dateFormatter2 dateFromString:_match.matchTime];
}

- (void)printMatchTime
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MMMM dd h:mma"];
    NSString *stringFromDate1 = [formatter stringFromDate:_dateFromString1];
    NSString *stringFromDate2 = [formatter stringFromDate:_dateFromString2];
    
    [_yourMatchTimeButton setTitle:stringFromDate1 forState:UIControlStateNormal];
    [_brazilMatchTimeButton setTitle:stringFromDate2 forState:UIControlStateNormal];
}

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

@end
