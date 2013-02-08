//
//  CTPViewController.m
//  CountingTestProject
//
//  Created by Tim Gostony on 2/8/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import "CTPViewController.h"

#import "UICountingLabel.h"

@interface CTPViewController ()

@end

@implementation CTPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    UICountingLabel* myLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    [self.view addSubview:myLabel];
    [myLabel setValue:100 withCountingMethod:UILabelCountingMethodLinear andDuration:5.0];
    [myLabel release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
