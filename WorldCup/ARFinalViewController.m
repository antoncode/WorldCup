//
//  ARFinalViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 5/6/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARFinalViewController.h"
#import "ARMatch.h"
#import "ARMatchDetailViewController.h"

@interface ARFinalViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *arrayOfMatchStrings;
@property (nonatomic, strong) NSMutableArray *arrayOfMatches;

@end

@implementation ARFinalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    self.navigationItem.title = @"Final";
    
    _arrayOfMatches = [NSMutableArray new];
    
    [self createArrayOfMatchStrings];
    [self setUpMatches];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableSidebar" object:nil];
}

#pragma mark - Table View data source

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayOfMatches.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    ARMatch *match = [_arrayOfMatches objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:17]];
    cell.textLabel.text = match.matchString;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showFinalMatchDetail"]) {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        ARMatch *match = [ARMatch new];
        match = [_arrayOfMatches objectAtIndex:indexPath.row];
        ARMatchDetailViewController *mdvc = (ARMatchDetailViewController *)segue.destinationViewController;
        
        mdvc.match = match;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disableSidebar" object:nil];
    }
}


#pragma mark - Helper methods

- (void)createArrayOfMatchStrings
{
    _arrayOfMatchStrings = @[@"Third-Place", @"Final"];
}

- (void)setUpMatches
{
    for (NSInteger x=0; x<_arrayOfMatchStrings.count; x++) {
        ARMatch *match = [ARMatch new];
        match.matchString = [NSString stringWithFormat:@"%@", [_arrayOfMatchStrings objectAtIndex:x]];
        [_arrayOfMatches addObject:match];
    }
}

@end
