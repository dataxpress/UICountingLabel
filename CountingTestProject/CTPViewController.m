//
//  CTPViewController.m
//  CountingTestProject
//
//  Created by Tim Gostony on 2/8/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import "CTPViewController.h"


@interface CTPViewController ()

@end

@implementation CTPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // make one that counts up
    UICountingLabel* myLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    [self.view addSubview:myLabel];
    [myLabel setValue:100 withCountingMethod:UILabelCountingMethodLinear andDuration:2.0];
    [myLabel release];
    
    // make one that counts up, using ease in out
    UICountingLabel* countingUpEaseInOutLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(10, 50, 100, 40)];
    [self.view addSubview:countingUpEaseInOutLabel];
    countingUpEaseInOutLabel.text = @"100";
    [countingUpEaseInOutLabel setValue:200 withCountingMethod:UILabelCountingMethodEaseInOut andDuration:2.0];
    [countingUpEaseInOutLabel release];
    
    
    
    // make one that counts down
    UICountingLabel* countingDownLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(10, 90, 100, 40)];
    [self.view addSubview:countingDownLabel];
    countingDownLabel.text = @"200";
    [countingDownLabel setValue:100 withCountingMethod:UILabelCountingMethodEaseOut andDuration:2.0];
    [countingDownLabel release];
    
    
    
    // example using a NIB-placed label and skipping arguments (defaults: method: easeinout, time: 2.0)
    [self.label setValue:1000];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_label release];
    [super dealloc];
}
@end
