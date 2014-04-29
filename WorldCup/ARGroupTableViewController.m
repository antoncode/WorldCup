//
//  ARGroupTableViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 4/28/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARGroupTableViewController.h"
#import "ARGroupMatchesViewController.h"

@interface ARGroupTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *groupsArray;
@property (nonatomic) NSArray *groupsNameArray;

@end

@implementation ARGroupTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.navigationItem.title = @"Groups";
    [self.navigationController setNavigationBarHidden:NO];
    
    [self createGroups];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
    
    cell.textLabel.text = _groupsNameArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showGroupMatches"]) {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        NSArray *selectedGroup = [_groupsArray objectAtIndex:indexPath.row];
        ARGroupMatchesViewController *gmvc = (ARGroupMatchesViewController *)segue.destinationViewController;

        gmvc.group = selectedGroup;
        gmvc.groupName = [_groupsNameArray objectAtIndex:indexPath.row];
        
    }
}

#pragma mark - Helper methods

- (void)createGroups
{
    _groupsNameArray = @[@"Group A", @"Group B", @"Group C", @"Group D", @"Group E", @"Group F", @"Group G", @"Group H"];
    
    
    NSArray *groupA, *groupB, *groupC, *groupD, *groupE, *groupF, *groupG, *groupH;
    
    groupA = @[@"Brazil", @"Croatia", @"Mexico", @"Cameroon"];
    groupB = @[@"Spain", @"Netherlands", @"Chile", @"Australia"];
    groupC = @[@"Colombia", @"Greece", @"Ivory Coast", @"Japan"];
    groupD = @[@"Uruguay", @"Costa Rica", @"England", @"Italy"];
    groupE = @[@"Switzerland", @"Ecuador", @"France", @"Honduras"];
    groupF = @[@"Argentina", @"Bosnia and Herzegovina", @"Iran", @"Nigeria"];
    groupG = @[@"Germany", @"Portugal", @"Ghana", @"USA"];
    groupH = @[@"Belgium", @"Algeria", @"Russia", @"Korea"];
    
    _groupsArray = @[groupA, groupB, groupC, groupD, groupE, groupF, groupG, groupH];
}

@end
