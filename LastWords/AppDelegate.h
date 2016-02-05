//
//  AppDelegate.h
//  LastWords
//
//  Created by Syed Muaz on 8/24/14.
//  Copyright (c) 2014 team41. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <Parse/Parse.h>
#import <RestKit/RestKit.h>

@class HomeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) HomeViewController *viewController;

@end
