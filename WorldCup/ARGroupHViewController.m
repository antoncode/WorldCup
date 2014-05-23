//
//  ARGroupHViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 5/5/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARGroupHViewController.h"
#import "ARMatch.h"
#import "ARMatchDetailViewController.h"

@interface ARGroupHViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *groupH;
@property (nonatomic, strong) NSMutableArray *arrayOfMatches;
@property (nonatomic, strong) NSDictionary *matchTimeDictionary;

@end

@implementation ARGroupHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    self.navigationItem.title = @"Group H";
    
    _arrayOfMatches = [NSMutableArray new];
    
    [self createGroupH];
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
    if ([segue.identifier isEqualToString:@"showHMatchDetail"]) {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        ARMatch *match = [_arrayOfMatches objectAtIndex:indexPath.row];
        ARMatchDetailViewController *mdvc = (ARMatchDetailViewController *)segue.destinationViewController;
        
        mdvc.match = match;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disableSidebar" object:nil];
    }
}

#pragma mark - Helper methods

- (void)createGroupH
{
    _groupH = @[@"Belgium", @"Algeria", @"Russia", @"Korea Republic"];
}

- (void)setUpMatches
{
    for (NSInteger x=0; x<_groupH.count; x++) {
        for (NSInteger y=0; y<_groupH.count; y++) {
            if (x != y) {       // TeamX vs TeamX not added
                ARMatch *match = [ARMatch new];
                match.matchString = [NSString stringWithFormat:@"%@ vs %@", [_groupH objectAtIndex:x], [_groupH objectAtIndex:y]];
                match.homeTeamName = [_groupH objectAtIndex:x];
                match.awayTeamName = [_groupH objectAtIndex:y];
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
    _matchTimeDictionary = @{@"Belgium vs Algeria"                 :@"06-17-2014 01:00PM",
                             @"Russia vs Korea Republic"           :@"06-17-2014 07:00PM",
                             @"Belgium vs Russia"                  :@"06-22-2014 01:00PM",
                             @"Korea Republic vs Algeria"          :@"06-22-2014 04:00PM",
                             @"Korea Republic vs Belgium"          :@"06-26-2014 05:00PM",
                             @"Algeria vs Russia"                  :@"06-26-2014 05:00PM"};
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
