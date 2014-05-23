//
//  ARTeamsViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 5/22/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARTeamsViewController.h"
#import "ARCustomTableViewCell.h"
#import "ARWebViewController.h"

@interface ARTeamsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *groupsArray, *tableArray;

@end

@implementation ARTeamsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _groupsArray = [[NSArray alloc]initWithObjects:@"Group A",@"Group B",@"Group C",@"Group D",@"Group E",@"Group F",@"Group G",@"Group H", nil];
    
    NSArray* groupAArray = [[NSArray alloc]initWithObjects:@"Brazil", @"Croatia", @"Mexico", @"Cameroon", nil];
    NSArray* groupBArray = [[NSArray alloc]initWithObjects:@"Spain", @"Netherlands", @"Chile", @"Australia", nil];
    NSArray* groupCArray = [[NSArray alloc]initWithObjects:@"Colombia", @"Greece", @"Ivory Coast", @"Japan", nil];
    NSArray* groupDArray = [[NSArray alloc]initWithObjects:@"Uruguay", @"Costa Rica", @"England", @"Italy", nil];
    NSArray* groupEArray = [[NSArray alloc]initWithObjects:@"Switzerland", @"Ecuador", @"France", @"Honduras", nil];
    NSArray* groupFArray = [[NSArray alloc]initWithObjects:@"Argentina", @"Bosnia Herzegovina", @"Iran", @"Nigeria", nil];
    NSArray* groupGArray = [[NSArray alloc]initWithObjects:@"Germany", @"Portugal", @"Ghana", @"USA", nil];
    NSArray* groupHArray = [[NSArray alloc]initWithObjects:@"Belgium", @"Algeria", @"Russia", @"Korea Republic", nil];
    
    _tableArray = [NSArray arrayWithObjects:groupAArray, groupBArray, groupCArray, groupDArray, groupEArray, groupFArray, groupGArray, groupHArray, nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _groupsArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_groupsArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_tableArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSString *teamName = [[_tableArray objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", teamName]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:17]];
    cell.label.text = teamName;

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showWebView"]) {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        NSString *teamName = [[_tableArray objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
        NSString *teamURL = [self retrieveTeamURL:teamName];

        ARWebViewController *wvc = (ARWebViewController *)segue.destinationViewController;
        wvc.teamURL = teamURL;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disableSidebar" object:nil];
    }
}

- (NSString *)retrieveTeamURL:(NSString *)teamName
{
    NSDictionary *codeURLDictionary = @{@"Brazil"               :@"43924",
                                        @"Croatia"              :@"43938",
                                        @"Mexico"               :@"43911",
                                        @"Cameroon"             :@"43849",
                                        @"Spain"                :@"43969",
                                        @"Netherlands"          :@"43960",
                                        @"Chile"                :@"43925",
                                        @"Australia"            :@"43976",
                                        @"Colombia"             :@"43926",
                                        @"Greece"               :@"43949",
                                        @"Ivory Coast"          :@"43854",
                                        @"Japan"                :@"43819",
                                        @"Uruguay"              :@"43930",
                                        @"Costa Rica"           :@"43901",
                                        @"England"              :@"43942",
                                        @"Italy"                :@"43954",
                                        @"Switzerland"          :@"43971",
                                        @"Ecuador"              :@"43927",
                                        @"France"               :@"43946",
                                        @"Honduras"             :@"43909",
                                        @"Argentina"            :@"43922",
                                        @"Bosnia Herzegovina"   :@"44037",
                                        @"Iran"                 :@"43817",
                                        @"Nigeria"              :@"43876",
                                        @"Germany"              :@"43948",
                                        @"Portugal"             :@"43963",
                                        @"Ghana"                :@"43860",
                                        @"USA"                  :@"43921",
                                        @"Belgium"              :@"43935",
                                        @"Algeria"              :@"43843",
                                        @"Russia"               :@"43965",
                                        @"Korea Republic"       :@"43822"};
    
    NSString *tempTeamURL = [NSString stringWithFormat:@"http://m.fifa.com/worldcup/teams/team=%@", [codeURLDictionary objectForKey:teamName]];
    return tempTeamURL;
}

@end
