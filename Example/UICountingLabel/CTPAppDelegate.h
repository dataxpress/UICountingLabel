//
//  CTPAppDelegate.h
//  CountingTestProject
//
//  Created by Tim Gostony on 2/8/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTPViewController;

@interface CTPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CTPViewController *viewController;

@end
