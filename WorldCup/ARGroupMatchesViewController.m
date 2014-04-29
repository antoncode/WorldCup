//
//  ARGroupMatchesViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 4/28/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARGroupMatchesViewController.h"
#import "ARMatchDetailViewController.h"
#import "ARMatch.h"

@interface ARGroupMatchesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfMatches;  // array of ARMatch

@end

@implementation ARGroupMatchesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    self.navigationItem.title = _groupName;
    
    [self setUpMatches];
}

#pragma mark - Table View data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayOfMatches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupMatchCell"];
    
    ARMatch *match = [_arrayOfMatches objectAtIndex:indexPath.row];
    cell.textLabel.text = match.matchString;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMatchDetail"]) {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        ARMatch *match = [ARMatch new];
        match = [_arrayOfMatches objectAtIndex:indexPath.row];
        ARMatchDetailViewController *mdvc = (ARMatchDetailViewController *)segue.destinationViewController;
        
        mdvc.match = match;
    }
}


#pragma mark - Helper methods

- (void)setUpMatches
{
    _arrayOfMatches = [NSMutableArray new];

    for (NSInteger x=0; x<_group.count; x++) {
        for (NSInteger y=0; y<_group.count; y++) {
            if (x != y) {       // Team vs same team is not added
                ARMatch *match = [ARMatch new];
                match.matchString = [NSString stringWithFormat:@"%@ vs %@", [_group objectAtIndex:x], [_group objectAtIndex:y]];
                match.homeTeam.teamName = [_group objectAtIndex:x];
                match.awayTeam.teamName = [_group objectAtIndex:y];
                [_arrayOfMatches addObject:match];
            }
        }
    }

    // Removing multiple occurences of the same match
    NSMutableIndexSet *indexToRemove = [NSMutableIndexSet new];
    [indexToRemove addIndex:2];
    [indexToRemove addIndex:3];
    [indexToRemove addIndex:5];
    [indexToRemove addIndex:6];
    [indexToRemove addIndex:7];
//    [indexToRemove addIndex:8];
    [indexToRemove addIndex:11];
    [_arrayOfMatches removeObjectsAtIndexes:indexToRemove];
    
    // Reorganizing array
    ARMatch *match = [_arrayOfMatches objectAtIndex:3];
    [_arrayOfMatches removeObjectAtIndex:3];
    [_arrayOfMatches insertObject:match atIndex:1];
    match = [_arrayOfMatches objectAtIndex:5];
    [_arrayOfMatches removeObjectAtIndex:5];
    [_arrayOfMatches insertObject:match atIndex:3];
    match = [_arrayOfMatches objectAtIndex:5];
    [_arrayOfMatches removeObjectAtIndex:5];
    [_arrayOfMatches insertObject:match atIndex:4];
    
    
    for (int i=0; i<_arrayOfMatches.count; i++) {
        ARMatch *match = _arrayOfMatches[i];
        NSLog(@"%@", match.matchString);
    }
}

@end
