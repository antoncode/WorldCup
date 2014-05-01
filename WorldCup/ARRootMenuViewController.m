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
    
    [self setUpChildViewControllers];
    
    [self setUpDrag];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableSidebar) name:@"enableSidebar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableSidebar) name:@"disableSidebar" object:nil];

    

}

- (void)enableSidebar
{
    NSLog(@"Enabling Sidebar");
    [_panRecognizer setEnabled:YES];
}

- (void)disableSidebar
{
    NSLog(@"Disabling Sidebar");
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
    [groupANavControl setNavigationBarHidden:YES animated:NO];
    
    ARGroupBViewController *groupBViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"groupB"];
    groupBViewController.title = @"Group B";
    UINavigationController *groupBNavControl = [[UINavigationController alloc] initWithRootViewController:groupBViewController];
    [groupBNavControl setNavigationBarHidden:YES animated:NO];
    
    _arrayOfViewControllers = @[countdownNavControl, groupANavControl, groupBNavControl];
    
    _topViewController = _arrayOfViewControllers[0];
    
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
            [UIView animateWithDuration:.4 animations:^{
                _topViewController.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }
}

- (void)openMenu
{
    [UIView animateWithDuration:.4 animations:^{
        _topViewController.view.frame = CGRectMake(self.view.frame.size.width * 0.75, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [_tapToClose addTarget:self action:@selector(closeMenu:)];
            [_topViewController.view addGestureRecognizer:_tapToClose];
            _menuIsOpen = YES;
            _tableView.userInteractionEnabled = YES;
        }
    }];
}

- (void)closeMenu:(id)sender
{
    [UIView animateWithDuration:.5 animations:^{
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
        
        [self closeMenu:nil];
    }];
}

@end
