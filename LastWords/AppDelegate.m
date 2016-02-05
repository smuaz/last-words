//
//  AppDelegate.m
//  LastWords
//
//  Created by Syed Muaz on 8/24/14.
//  Copyright (c) 2014 team41. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"3K2614D1mplkus5O0vwWVxzVilhs2CxcdwlLZz6a"
                  clientKey:@"d6ClOUgc1V4pU436bljWbAlvjFauaYyWuo2aATAq"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [self setupRestKit];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    //self.navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    //[self.navController setNavigationBarHidden:YES];
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


    return YES;

}

- (void)setupRestKit{
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://stylade.aurora.sology.eu"]];
    [[manager HTTPClient] setAuthorizationHeaderWithUsername:@"stylade" password:@"s7yl4d3"];
    [[manager HTTPClient] setDefaultHeader:@"X-API-TOKEN" value:@"VHbyzWjsbdPMfzopir69c7Z3rbqYzLo8hg"];
    [[manager HTTPClient] setDefaultHeader:@"X-API-EMAIL" value:@"syedmuaz@gmail.com"];
    
    //NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    //RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    //manager.managedObjectStore = managedObjectStore;
    
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    [errorMapping addPropertyMapping:
     [RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                                    pathPattern:nil
                                                                                        keyPath:@"error" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    [manager addResponseDescriptorsFromArray:@[errorDescriptor]];
  
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    //[currentInstallation addUniqueObject:newDeviceToken forKey:[PFUser currentUser].objectId];
    
    [currentInstallation saveInBackground];
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    NSLog(@"userinfo: %@",userInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveRemoteNotification" object:nil];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
