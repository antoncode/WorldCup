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
    [self setUpMatches];
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
    cell.textLabel.text = match.matchString;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
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



@end
