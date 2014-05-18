//
//  ARRootViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 4/30/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARRootMenuViewController.h"
#import "ARCountdownViewController.h"
#import "ARGroupAViewController.h"
#import "ARGroupBViewController.h"
#import "ARGroupCViewController.h"
#import "ARGroupDViewController.h"
#import "ARGroupEViewController.h"
#import "ARGroupFViewController.h"
#import "ARGroupGViewController.h"
#import "ARGroupHViewController.h"
#import "ARRoundOfSixteenViewController.h"
#import "ARQuarterFinalViewController.h"
#import "ARSemiFinalViewController.h"
#import "ARFinalViewController.h"

@interface ARRootMenuViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *arrayOfViewControllers;
@property (strong,nonatomic) UIViewController *topViewController;
@property (strong,nonatomic) UITapGestureRecognizer *tapToClose;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic) BOOL menuIsOpen;
@end

@implementation ARRootMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.userInteractionEnabled = NO;
    
    _tapToClose = [UITapGestureRecognizer new];
    _menuIsOpen = NO;
    
    [self setUpChildViewControllers];
    [self setUpDrag];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableSidebar) name:@"enableSidebar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableSidebar) name:@"disableSidebar" object:nil];
}

- (void)enableSidebar
{
    [_panRecognizer setEnabled:YES];
}

- (void)disableSidebar
{
    [_panRecognizer setEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - Table View data source

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfViewControllers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:17]];
    cell.textLabel.text = [self.arrayOfViewControllers[indexPath.row] title];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self switchToViewControllerAtIndexPath:(indexPath)];
}

#pragma mark - Other

- (void)setUpChildViewControllers
{
    ARCountdownViewController *countdownViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"countdown"];
    countdownViewController.title = @"Countdown";
    UINavigationController *countdownNavControl = [[UINavigationController alloc] initWithRootViewController:countdownViewController];
    [countdownNavControl setNavigationBarHidden:YES animated:NO];
    
    ARGroupAViewController *groupAViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"groupA"];
    groupAViewController.title = @"Group A";
    UINavigationController *groupANavControl = [[UINavigationController alloc] initWithRootViewController:groupAViewController];
    [groupANavControl setNavigationBarHidden:NO animated:NO];
    
    ARGroupBViewController *groupBViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"groupB"];
    groupBViewController.title = @"Group B";
    UINavigationController *groupBNavControl = [[UINavigationController alloc] initWithRootViewController:groupBViewController];
    [groupBNavControl setNavigationBarHidden:NO animated:NO];
    
    ARGroupCViewController *groupCViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"groupC"];
    groupCViewController.title = @"Group C";
    UINavigationController *groupCNavControl = [[UINavigationController alloc] initWithRootViewController:groupCViewController];
    [groupCNavControl setNavigationBarHidden:NO animated:NO];
    
    ARGroupDViewController *groupDViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"groupD"];
    groupDViewController.title = @"Group D";
    UINavigationController *groupDNavControl = [[UINavigationController alloc] initWithRootViewController:groupDViewController];
    [groupDNavControl setNavigationBarHidden:NO animated:NO];
    
    ARGroupEViewController *groupEViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"groupE"];
    groupEViewController.title = @"Group E";
    UINavigationController *groupENavControl = [[UINavigationController alloc] initWithRootViewController:groupEViewController];
    [groupENavControl setNavigationBarHidden:NO animated:NO];
    
    ARGroupFViewController *groupFViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"groupF"];
    groupFViewController.title = @"Group F";
    UINavigationController *groupFNavControl = [[UINavigationController alloc] initWithRootViewController:groupFViewController];
    [groupFNavControl setNavigationBarHidden:NO animated:NO];

    ARGroupGViewController *groupGViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"groupG"];
    groupGViewController.title = @"Group G";
    UINavigationController *groupGNavControl = [[UINavigationController alloc] initWithRootViewController:groupGViewController];
    [groupGNavControl setNavigationBarHidden:NO animated:NO];
    
    ARGroupHViewController *groupHViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"groupH"];
    groupHViewController.title = @"Group H";
    UINavigationController *groupHNavControl = [[UINavigationController alloc] initWithRootViewController:groupHViewController];
    [groupHNavControl setNavigationBarHidden:NO animated:NO];
    
    ARRoundOfSixteenViewController *roundOfSixteenViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"roundOfSixteen"];
    roundOfSixteenViewController.title = @"Round of Sixteen";
    UINavigationController *roundOfSixteenNavControl = [[UINavigationController alloc] initWithRootViewController:roundOfSixteenViewController];
    [roundOfSixteenNavControl setNavigationBarHidden:NO animated:NO];
    
    ARQuarterFinalViewController *quarterFinalViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"quarterFinal"];
    quarterFinalViewController.title = @"Quarter-Final";
    UINavigationController *quarterFinalNavControl = [[UINavigationController alloc] initWithRootViewController:quarterFinalViewController];
    [quarterFinalNavControl setNavigationBarHidden:NO animated:NO];
    
    ARSemiFinalViewController *semiFinalViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"semiFinal"];
    semiFinalViewController.title = @"Semi-Final";
    UINavigationController *semiFinalNavControl = [[UINavigationController alloc] initWithRootViewController:semiFinalViewController];
    [semiFinalNavControl setNavigationBarHidden:NO animated:NO];
    
    ARFinalViewController *finalViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"final"];
    finalViewController.title = @"Final";
    UINavigationController *finalNavControl = [[UINavigationController alloc] initWithRootViewController:finalViewController];
    [finalNavControl setNavigationBarHidden:NO animated:NO];
    
    _arrayOfViewControllers = @[countdownNavControl, groupANavControl, groupBNavControl, groupCNavControl, groupDNavControl, groupENavControl, groupFNavControl, groupGNavControl, groupHNavControl, roundOfSixteenNavControl, quarterFinalNavControl, semiFinalNavControl, finalNavControl];
    
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
    if ([now compare:kickOffDate] == NSOrderedAscending) {
        _topViewController = _arrayOfViewControllers[0];
    } else {
        // World Cup has started, countdown zeroed out
        _topViewController = _arrayOfViewControllers[1];
    }
    
    [self addChildViewController:_topViewController];
    [self.view addSubview:_topViewController.view];
    [_topViewController didMoveToParentViewController:self];
}

- (void)setUpDrag
{
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    
    _panRecognizer.minimumNumberOfTouches = 1;
    _panRecognizer.maximumNumberOfTouches = 1;
    
    _panRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:_panRecognizer];
}

- (void)movePanel:(id)sender
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    
    CGPoint translatedPoint = [pan translationInView:self.view];
    
    if (_menuIsOpen == NO) {
        if (pan.state == UIGestureRecognizerStateChanged) {
            if (translatedPoint.x > 0) {
                _topViewController.view.center = CGPointMake(_topViewController.view.center.x + translatedPoint.x, _topViewController.view.center.y);
                [pan setTranslation:CGPointZero inView:self.view];
            }
        }
        if (pan.state == UIGestureRecognizerStateEnded) {
            if (_topViewController.view.frame.origin.x > self.view.frame.size.width / 5) {
                [self openMenu];
            } else {
                [UIView animateWithDuration:.3 animations:^{
                    _topViewController.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                }];
            }
        }
    }
    
    if (_menuIsOpen) {
        if (translatedPoint.x < 0) {
            _topViewController.view.center = CGPointMake(_topViewController.view.center.x + translatedPoint.x, _topViewController.view.center.y);
            [pan setTranslation:CGPointZero inView:self.view];
        }
        if (pan.state == UIGestureRecognizerStateEnded) {
            if (_topViewController.view.frame.origin.x < self.view.frame.size.width / 2) {
                [self closeMenu];
            } else {
                [UIView animateWithDuration:.3 animations:^{
                    _topViewController.view.frame = CGRectMake(self.view.frame.size.width * 0.75, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                }];
            }
        }
    }
}

- (void)openMenu
{
    [UIView animateWithDuration:.3 animations:^{
        _topViewController.view.frame = CGRectMake(self.view.frame.size.width * 0.75, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [_tapToClose addTarget:self action:@selector(closeMenu)];
            [_topViewController.view addGestureRecognizer:_tapToClose];
            _menuIsOpen = YES;
            _tableView.userInteractionEnabled = YES;
        }
    }];
}

- (void)closeMenu
{
    [UIView animateWithDuration:.3 animations:^{
        _topViewController.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        [_topViewController.view removeGestureRecognizer:_tapToClose];
        _menuIsOpen = NO;
    }];        
}

-(void)switchToViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:.2 animations:^{
        _topViewController.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        CGRect offScreen = _topViewController.view.frame;
        
        [_topViewController.view removeFromSuperview];
        [_topViewController removeFromParentViewController];
        
        _topViewController = _arrayOfViewControllers[indexPath.row];
        [self addChildViewController:_topViewController];
        _topViewController.view.frame = offScreen;
                
        [self.view addSubview:_topViewController.view];
        
        [_topViewController didMoveToParentViewController:self];
        
        [self closeMenu];
    }];
}

@end
