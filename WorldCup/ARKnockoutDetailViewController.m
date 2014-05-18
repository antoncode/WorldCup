//
//  ARKnockoutDetailViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 5/9/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARKnockoutDetailViewController.h"

@interface ARKnockoutDetailViewController ()

//@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) NSDate *dateFromString1, *dateFromString2;
@property (weak, nonatomic) IBOutlet UILabel *matchStringLabel;
@property (weak, nonatomic) IBOutlet UIButton *yourMatchTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *brazilMatchTimeButton;
@property (nonatomic, strong) IBOutlet UIDatePicker *popUpDatePicker;
@property (nonatomic, strong) IBOutlet UIButton *setReminderButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelReminderButton;

@end

@implementation ARKnockoutDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = _match.matchString;
    _matchStringLabel.text = _match.matchString;
    
    [self findMatchTime];
    [self printMatchTime];
    
    [self setUpReminderButton];
    [self setUpDatePicker];
    [self setUpCancelButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self setupPanGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.view removeGestureRecognizer:_panRecognizer];
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

#pragma mark - Gesture Recognizers

//- (void)setupPanGesture
//{
//    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
//    
//    _panRecognizer.minimumNumberOfTouches = 1;
//    _panRecognizer.maximumNumberOfTouches = 1;
//    
//    [self.view addGestureRecognizer:_panRecognizer];
//}

#pragma mark - Helper methods

- (void)findMatchTime
{
    NSDictionary *matchDictionary = @{@"1A vs 2B"                           :@"06-28-2014 01:00PM",
                                      @"1C vs 2D"                           :@"06-28-2014 05:00PM",
                                      @"1B vs 2A"                           :@"06-29-2014 01:00PM",
                                      @"1D vs 2C"                           :@"06-29-2014 05:00PM",
                                      @"1E vs 2F"                           :@"06-30-2014 01:00PM",
                                      @"1G vs 2H"                           :@"06-30-2014 05:00PM",
                                      @"1F vs 2E"                           :@"07-01-2014 01:00PM",
                                      @"1H vs 2G"                           :@"07-01-2014 05:00PM",
                                      @"W53 vs W54"                         :@"07-04-2014 01:00PM",
                                      @"W49 vs W50"                         :@"07-04-2014 05:00PM",
                                      @"W55 vs W56"                         :@"07-05-2014 01:00PM",
                                      @"W51 vs W52"                         :@"07-05-2014 05:00PM",
                                      @"W57 vs W58"                         :@"07-08-2014 05:00PM",
                                      @"W59 vs W60"                         :@"07-09-2014 05:00PM",
                                      @"Third-Place"                        :@"07-12-2014 05:00PM",
                                      @"Final"                              :@"07-13-2014 04:00PM"};
    
    _match.matchTime = [matchDictionary objectForKey:_match.matchString];
    
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


@end
