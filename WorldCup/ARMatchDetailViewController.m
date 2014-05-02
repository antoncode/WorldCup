//
//  ARMatchDetailViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 4/28/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARMatchDetailViewController.h"

@interface ARMatchDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *homeTeamImageView;
@property (weak, nonatomic) IBOutlet UIImageView *awayTeamImageView;
@property (weak, nonatomic) IBOutlet UIButton *homeTeamButton;
@property (weak, nonatomic) IBOutlet UIButton *awayTeamButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@end

@implementation ARMatchDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = _match.matchString;
    
    [_homeTeamButton setTitle:_match.homeTeamName forState:UIControlStateNormal];
    [_awayTeamButton setTitle:_match.awayTeamName forState:UIControlStateNormal];
    
    [self findMatchTime];
    [self printMatchTime];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupPanGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view removeGestureRecognizer:_panRecognizer];
}

#pragma mark - Gesture Recognizers

//- (void)setupSwipeGesture
//{
//    //MatchDetail
//    _swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pushNextGame)];
//    _swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:_swipeRecognizer];
//}

//- (void)pushNextGame
//{
//    ARMatchDetailViewController *mdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchDetail"];
//    mdvc.match = _nextMatch;
//    [self.navigationController pushViewController:mdvc animated:YES];
//}

- (void)setupPanGesture
{
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    _panRecognizer.minimumNumberOfTouches = 1;
    _panRecognizer.maximumNumberOfTouches = 1;
    
    [self.view addGestureRecognizer:_panRecognizer];
}

- (IBAction)homeTeamWin:(id)sender
{
    _homeTeamImageView.image = [UIImage imageNamed:@"win.png"];
    _awayTeamImageView.image = [UIImage imageNamed:@"lose.png"];
}

- (IBAction)awayTeamWin:(id)sender
{
    _homeTeamImageView.image = [UIImage imageNamed:@"lose.png"];
    _awayTeamImageView.image = [UIImage imageNamed:@"win.png"];
}

- (void)printMatchTime
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    NSDate *gameTime = [dateFormatter dateFromString:_match.matchTime];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    
    _dateLabel.text = _match.matchTime;
//    _timeLabel.text = [formatter stringFromDate:_match.time];
}

- (void)findMatchTime
{
    NSDictionary *matchDictionary = @{@"Brazil vs Croatia"      :@"06-12-2014 14:00:00",
                                      @"Mexico vs Brazil"       :@"06-13-2014 10:00:00"};
    
    _match.matchTime = [matchDictionary objectForKey:_match.matchString];
}


@end
