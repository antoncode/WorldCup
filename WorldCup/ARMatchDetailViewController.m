//
//  ARMatchDetailViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 4/28/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARMatchDetailViewController.h"

@interface ARMatchDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *matchStringLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *arenaLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (nonatomic) NSDictionary *matchDictionary;

@end

@implementation ARMatchDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = _match.matchString;
    
    [self findMatchDetail];
    
    [self printMatchDetail];
}

- (void)findMatchDetail
{
    if ([_match.matchString isEqualToString:@"Brazil vs Croatia"]) {
//        _match.time = @"1:00pm";
//        _match.date = @"Jun 12, 2014";
        _match.arena = @"Arena de Sao Paulo";
        _match.group = @"Group A";
    } else if ([_match.matchString isEqualToString:@"Brazil vs Mexico"]) {
//        _match.time = @"12:00pm";
//        _match.date = @"Jun 17, 2014";
        _match.arena = @"Estadio Castelao";
        _match.group = @"Group A";
    } 
}

- (void)printMatchDetail
{
    _matchStringLabel.text = _match.matchString;
    _timeLabel.text = [NSDateFormatter localizedStringFromDate:_match.time
                                                     dateStyle:NSDateFormatterShortStyle
                                                     timeStyle:NSDateFormatterFullStyle];
    _dateLabel.text = [NSDateFormatter localizedStringFromDate:_match.date
                                                     dateStyle:NSDateFormatterShortStyle
                                                     timeStyle:NSDateFormatterFullStyle];
    _arenaLabel.text = _match.arena;
    _groupLabel.text = _match.group;
}



@end
