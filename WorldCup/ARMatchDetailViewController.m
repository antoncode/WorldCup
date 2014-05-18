//
//  ARMatchDetailViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 4/28/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARMatchDetailViewController.h"

@interface ARMatchDetailViewController ()

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) NSDate *dateFromString1, *dateFromString2;
@property (weak, nonatomic) IBOutlet UIImageView *teamOneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *teamTwoImageView;
@property (weak, nonatomic) IBOutlet UIButton *yourMatchTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *brazilMatchTimeButton;
@property (nonatomic, strong) IBOutlet UIDatePicker *popUpDatePicker;
@property (nonatomic, strong) IBOutlet UIButton *setReminderButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelReminderButton;

@end

@implementation ARMatchDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = _match.matchString;
    //[self setUpTeamFlags];
    
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
//    [self setupPanGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

#pragma mark - Gesture Recognizers

//- (void)setupPanGesture
//{
//    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController action:@selector(closeMatchDetail)];
//    
//    _panRecognizer.minimumNumberOfTouches = 1;
//    _panRecognizer.maximumNumberOfTouches = 1;
//    
//    [self.view addGestureRecognizer:_panRecognizer];
//}
//
//- (void)closeMatchDetail
//{
//    if (<#condition#>) {
//        <#statements#>
//    }
//    [self.navigationController popToViewController:self animated:YES];
//}

#pragma mark - Helper methods

- (void)setUpTeamFlags
{
    _teamOneImageView.layer.cornerRadius = 38;
    _teamOneImageView.layer.masksToBounds = NO;
    _teamOneImageView.clipsToBounds = YES;
    _teamOneImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", _match.homeTeamName]];
    
    _teamTwoImageView.layer.cornerRadius = 38;
    _teamTwoImageView.layer.masksToBounds = NO;
    _teamTwoImageView.clipsToBounds = YES;
    _teamTwoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", _match.awayTeamName]];
}

- (void)findMatchTime
{
    NSDictionary *matchDictionary = @{@"Brazil vs Croatia"                  :@"06-12-2014 05:00PM",
                                      @"Mexico vs Cameroon"                 :@"06-13-2014 01:00PM",
                                      @"Spain vs Netherlands"               :@"06-13-2014 04:00PM",
                                      @"Chile vs Australia"                 :@"06-13-2014 06:00PM",
                                      @"Colombia vs Greece"                 :@"06-14-2014 01:00PM",
                                      @"Uruguay vs Costa Rica"              :@"06-14-2014 04:00PM",
                                      @"England vs Italy"                   :@"06-14-2014 06:00PM",
                                      @"Ivory Coast vs Japan"               :@"06-14-2014 10:00PM",
                                      @"Switzerland vs Ecuador"             :@"06-15-2014 01:00PM",
                                      @"France vs Honduras"                 :@"06-15-2014 04:00PM",
                                      @"Argentina vs Bosnia Herzegovina"    :@"06-15-2014 07:00PM",
                                      @"Germany vs Portugal"                :@"06-16-2014 01:00PM",
                                      @"Iran vs Nigeria"                    :@"06-16-2014 04:00PM",
                                      @"Ghana vs USA"                       :@"06-16-2014 07:00PM",
                                      @"Belgium vs Algeria"                 :@"06-17-2014 01:00PM",
                                      @"Brazil vs Mexico"                   :@"06-17-2014 04:00PM",
                                      @"Russia vs Korea Republic"           :@"06-17-2014 06:00PM",
                                      @"Australia vs Netherlands"           :@"06-18-2014 01:00PM",
                                      @"Spain vs Chile"                     :@"06-18-2014 04:00PM",
                                      @"Cameroon vs Croatia"                :@"06-18-2014 06:00PM",
                                      @"Colombia vs Ivory Coast"            :@"06-19-2014 01:00PM",
                                      @"Uruguay vs England"                 :@"06-19-2014 04:00PM",
                                      @"Japan vs Greece"                    :@"06-19-2014 07:00PM",
                                      @"Italy vs Costa Rica"                :@"06-20-2014 01:00PM",
                                      @"Switzerland vs France"              :@"06-20-2014 04:00PM",
                                      @"Honduras vs Ecuador"                :@"06-20-2014 07:00PM",
                                      @"Argentina vs Iran"                  :@"06-21-2014 01:00PM",
                                      @"Germany vs Ghana"                   :@"06-21-2014 04:00PM",
                                      @"Nigeria vs Bosnia Herzegovina"      :@"06-21-2014 06:00PM",
                                      @"Belgium vs Russia"                  :@"06-22-2014 01:00PM",
                                      @"Korea Republic vs Algeria"          :@"06-22-2014 04:00PM",
                                      @"USA vs Portugal"                    :@"06-22-2014 06:00PM",
                                      @"Netherlands vs Chile"               :@"06-23-2014 01:00PM",
                                      @"Australia vs Spain"                 :@"06-23-2014 01:00PM",
                                      @"Cameroon vs Brazil"                 :@"06-23-2014 05:00PM",
                                      @"Croatia vs Mexico"                  :@"06-23-2014 05:00PM",
                                      @"Italy vs Uruguay"                   :@"06-24-2014 01:00PM",
                                      @"Costa Rica vs England"              :@"06-24-2014 01:00PM",
                                      @"Japan vs Colombia"                  :@"06-24-2014 05:00PM",
                                      @"Greece vs Ivory Coast"              :@"06-24-2014 05:00PM",
                                      @"Nigeria vs Argentina"               :@"06-25-2014 01:00PM",
                                      @"Bosnia Herzegovina vs Iran"         :@"06-25-2014 01:00PM",
                                      @"Honduras vs Switzerland"            :@"06-25-2014 05:00PM",
                                      @"Ecuador vs France"                  :@"06-25-2014 05:00PM",
                                      @"Portugal vs Ghana"                  :@"06-26-2014 01:00PM",
                                      @"USA vs Germany"                     :@"06-26-2014 01:00PM",
                                      @"Korea Republic vs Belgium"          :@"06-26-2014 05:00PM",
                                      @"Algeria vs Russia"                  :@"06-26-2014 05:00PM"};
    
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
