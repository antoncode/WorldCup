//
//  ARGroupAViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 4/30/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARGroupAViewController.h"
#import "ARMatch.h"
#import "ARMatchDetailViewController.h"

@interface ARGroupAViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *groupA;
@property (nonatomic, strong) NSMutableArray *arrayOfMatches;
@property (nonatomic, strong) NSDictionary *matchTimeDictionary;

@end

@implementation ARGroupAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    self.navigationItem.title = @"Group A";
    
    _arrayOfMatches = [NSMutableArray new];
    
    [self createGroupA];
    [self setUpMatchTimeDictionary];
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
    cell.detailTextLabel.text = [self printMatchTime:match.matchTime];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showAMatchDetail"]) {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        ARMatch *match = [ARMatch new];
        match = [_arrayOfMatches objectAtIndex:indexPath.row];
        ARMatchDetailViewController *mdvc = (ARMatchDetailViewController *)segue.destinationViewController;
        
        mdvc.match = match;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disableSidebar" object:nil];
    }
}


#pragma mark - Helper methods

- (void)createGroupA
{
    _groupA = @[@"Brazil", @"Croatia", @"Mexico", @"Cameroon"];
}

- (void)setUpMatches
{
    for (NSInteger x=0; x<_groupA.count; x++) {
        for (NSInteger y=0; y<_groupA.count; y++) {
            if (x != y) {       // TeamX vs TeamX not added
                ARMatch *match = [ARMatch new];
                match.matchString = [NSString stringWithFormat:@"%@ vs %@", [_groupA objectAtIndex:x], [_groupA objectAtIndex:y]];
                match.homeTeamName = [_groupA objectAtIndex:x];
                match.awayTeamName = [_groupA objectAtIndex:y];
                match.matchTime = [_matchTimeDictionary objectForKey:match.matchString];
                [_arrayOfMatches addObject:match];
            }
        }
    }
    
    // Removing incorrect match instances
    NSMutableIndexSet *indexToRemove = [NSMutableIndexSet new];
    [indexToRemove addIndex:2];
    [indexToRemove addIndex:3];
    [indexToRemove addIndex:5];
    [indexToRemove addIndex:6];
    [indexToRemove addIndex:7];
    [indexToRemove addIndex:11];
    [_arrayOfMatches removeObjectsAtIndexes:indexToRemove];
    
    // Reorganizing array chronologically
    ARMatch *match = [_arrayOfMatches objectAtIndex:3];
    [_arrayOfMatches removeObjectAtIndex:3];
    [_arrayOfMatches insertObject:match atIndex:1];
    match = [_arrayOfMatches objectAtIndex:5];
    [_arrayOfMatches removeObjectAtIndex:5];
    [_arrayOfMatches insertObject:match atIndex:3];
    match = [_arrayOfMatches objectAtIndex:5];
    [_arrayOfMatches removeObjectAtIndex:5];
    [_arrayOfMatches insertObject:match atIndex:4];
}

- (void)setUpMatchTimeDictionary
{
    _matchTimeDictionary = @{@"Brazil vs Croatia"                  :@"06-12-2014 05:00PM",
                             @"Mexico vs Cameroon"                 :@"06-13-2014 01:00PM",
                             @"Brazil vs Mexico"                   :@"06-17-2014 04:00PM",
                             @"Cameroon vs Croatia"                :@"06-18-2014 07:00PM",
                             @"Cameroon vs Brazil"                 :@"06-23-2014 05:00PM",
                             @"Croatia vs Mexico"                  :@"06-23-2014 05:00PM"};
}

- (NSString *)printMatchTime:(NSString *)matchTime
{
    NSDate *dateFromString = [NSDate new];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mma"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/Sao_Paulo"]];
    dateFromString = [dateFormatter dateFromString:matchTime];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MMMM dd h:mma"];
    NSString *stringFromDate = [formatter stringFromDate:dateFromString];
    
    return stringFromDate;
}

@end
