//
//  ARTeamsViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 5/22/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARTeamsViewController.h"
#import "ARCustomTableViewCell.h"

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
    
    NSString *countryName = [[_tableArray objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", countryName]];
    cell.label.text = countryName;

    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
