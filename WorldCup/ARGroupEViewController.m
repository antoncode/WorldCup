//
//  ARGroupEViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 5/5/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARGroupEViewController.h"
#import "ARMatch.h"
#import "ARMatchDetailViewController.h"

@interface ARGroupEViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *groupE;
@property (nonatomic, strong) NSMutableArray *arrayOfMatches;
@property (nonatomic, strong) NSDictionary *matchTimeDictionary;

@end

@implementation ARGroupEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    self.navigationItem.title = @"Group E";
    
    _arrayOfMatches = [NSMutableArray new];
    
    [self createGroupE];
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
    if ([segue.identifier isEqualToString:@"showEMatchDetail"]) {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        ARMatch *match = [_arrayOfMatches objectAtIndex:indexPath.row];
        ARMatchDetailViewController *mdvc = (ARMatchDetailViewController *)segue.destinationViewController;
        
        mdvc.match = match;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disableSidebar" object:nil];
    }
}

#pragma mark - Helper methods

- (void)createGroupE
{
    _groupE = @[@"Switzerland", @"Ecuador", @"France", @"Honduras"];
}

- (void)setUpMatches
{
    for (NSInteger x=0; x<_groupE.count; x++) {
        for (NSInteger y=0; y<_groupE.count; y++) {
            if (x != y) {       // TeamX vs TeamX not added
                ARMatch *match = [ARMatch new];
                match.matchString = [NSString stringWithFormat:@"%@ vs %@", [_groupE objectAtIndex:x], [_groupE objectAtIndex:y]];
                match.homeTeamName = [_groupE objectAtIndex:x];
                match.awayTeamName = [_groupE objectAtIndex:y];
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
    _matchTimeDictionary = @{@"Switzerland vs Ecuador"             :@"06-15-2014 01:00PM",
                             @"France vs Honduras"                 :@"06-15-2014 04:00PM",
                             @"Switzerland vs France"              :@"06-20-2014 04:00PM",
                             @"Honduras vs Ecuador"                :@"06-20-2014 07:00PM",
                             @"Honduras vs Switzerland"            :@"06-25-2014 05:00PM",
                             @"Ecuador vs France"                  :@"06-25-2014 05:00PM"};
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
