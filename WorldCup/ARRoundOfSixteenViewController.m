//
//  ARRoundOfSixteenViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 5/6/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARRoundOfSixteenViewController.h"
#import "ARMatch.h"
#import "ARMatchDetailViewController.h"

@interface ARRoundOfSixteenViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *arrayOfMatchStrings;
@property (nonatomic, strong) NSMutableArray *arrayOfMatches;
@property (nonatomic, strong) NSDictionary *matchTimeDictionary;

@end

@implementation ARRoundOfSixteenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    self.navigationItem.title = @"Round of Sixteen";
    
    _arrayOfMatches = [NSMutableArray new];
    
    [self createArrayOfMatchStrings];
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
    if ([segue.identifier isEqualToString:@"showSixteenMatchDetail"]) {
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
    _arrayOfMatchStrings = @[@"1A vs 2B", @"1C vs 2D", @"1B vs 2A", @"1D vs 2C", @"1E vs 2F", @"1G vs 2H", @"1F vs 2E", @"1H vs 2G"];
}

- (void)setUpMatches
{
    for (NSInteger x=0; x<_arrayOfMatchStrings.count; x++) {
            ARMatch *match = [ARMatch new];
            match.matchString = [NSString stringWithFormat:@"%@", [_arrayOfMatchStrings objectAtIndex:x]];
            match.matchTime = [_matchTimeDictionary objectForKey:match.matchString];
            [_arrayOfMatches addObject:match];
    }
}

- (void)setUpMatchTimeDictionary
{
    _matchTimeDictionary = @{@"1A vs 2B"                           :@"06-28-2014 01:00PM",
                             @"1C vs 2D"                           :@"06-28-2014 05:00PM",
                             @"1B vs 2A"                           :@"06-29-2014 01:00PM",
                             @"1D vs 2C"                           :@"06-29-2014 05:00PM",
                             @"1E vs 2F"                           :@"06-30-2014 01:00PM",
                             @"1G vs 2H"                           :@"06-30-2014 05:00PM",
                             @"1F vs 2E"                           :@"07-01-2014 01:00PM",
                             @"1H vs 2G"                           :@"07-01-2014 05:00PM"};
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
