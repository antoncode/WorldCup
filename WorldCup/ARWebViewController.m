//
//  ARWebViewController.m
//  WorldCup
//
//  Created by Anton Rivera on 5/18/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "ARWebViewController.h"

@interface ARWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ARWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_teamURL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:604800];
    [_webView loadRequest:urlRequest];
}

@end
