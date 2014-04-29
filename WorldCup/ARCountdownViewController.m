//
//  ARCountdownViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 4/29/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARCountdownViewController.h"
#import "ARGroupTableViewController.h"

@interface ARCountdownViewController ()

@end

@implementation ARCountdownViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showGroups"]) {
        
    }
}

@end
