//
//  AppDelegate.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "AppDelegate.h"
#import "BBSSideMenuViewController.h"
#import "BBSTabBarController.h"
#import "XLNParser.h"
#import "XLNDatabaseManager.h"

#import <SWRevealViewController.h>

//#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    BBSSideMenuViewController *sideMenuController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sideMenuController"];
    BBSTabBarController *tabbarContrller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarController"];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:sideMenuController frontViewController:tabbarContrller];
    revealController.rearViewRevealWidth = self.window.frame.size.width - (self.window.frame.size.width * 0.25);
    self.window.rootViewController = revealController;
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.14 green:0.37 blue:0.51 alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //NSURL *url = [NSURL URLWithString:@"http://barbarys.com/aggregator/aggregatorall/yml.xml"];
    //[[XLNParser alloc] ininWithURL:url];
    
    XLNDatabaseManager *dbManager = [[XLNDatabaseManager alloc] init];
    [dbManager createDB];
    
 //   [Crashlytics startWithAPIKey:@"5160aff135d1eeb3ab1ce005c131cbefc33b2fe2"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
