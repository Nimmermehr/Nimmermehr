//
//  MTAppDelegate.m
//  iStream
//
//  Created by Thomas Kober on 3/28/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTAppDelegate.h"
#import "MTTwitterConnector.h"
#import "MTServiceConnectorManager.h"
#import "MTNewsItem.h"

@implementation MTAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    MTServiceConnectorManager *mgr = [MTServiceConnectorManager sharedServiceConnectorManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTwitterAuthenticated:) name:MTTwitterAuthenticationSucceeded object:mgr];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTwitterContentReceived:) name:MTTwitterNewsItemsReceived object:mgr];
    
    // Pre-loaded from UserDefaults in final version
    // If nothing is in the User Defaults --> Show ServiceLogin Screen
    [mgr createAndConnectService:MTServiceTypeTwitter];
    
    [mgr authenticateServices];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

// Service Notification Handlers
- (void)handleTwitterAuthenticated:(NSNotification *)notification
{
    NSLog(@"%@.%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), notification);
    
    [[MTServiceConnectorManager sharedServiceConnectorManager] requestTwitterUserTimeline];
}

- (void)handleTwitterContentReceived:(NSNotification *)notification
{
    NSLog(@"%@.%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), notification);
    
    NSLog(@"%@.%@: %@=[%@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd), MTServiceTypeKey, [[notification userInfo] objectForKey:MTServiceTypeKey]);
    
    NSLog(@"%@.%@: %@=[%@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd), MTServiceContentKey, [[notification userInfo] objectForKey:MTServiceContentKey]);
}


@end
