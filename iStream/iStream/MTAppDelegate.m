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

/**
 * MTServiceConnectorManager Notification Overview:
 * 
 * MTTwitterAuthenticationSucceeded     // Twitter Auth successful
 * MTTwitterAuthenticationFailed        // Twitter Auth failed (contains userInfo dict)
 * MTTwitterConnectionInterrupted       // Twitter Connection interrupted (contains userInfo dict, but not used yet)
 * MTTwitterConnectionReEstablished     // Twitter Connection re-established
 * MTTwitterAccessNotGranted            // Twitter access not granted by user
 * MTTwitterNewsItemsReceived           // Twitter items received (contains userInfo dict)
 * MTTwitterNewsItemsRequestFailed      // Twitter news item request failed (contains userInfo dict)
 * MTTwitterLogoutCompleted             // Twitter logout finished successfully
 *
 * MTFacebookAuthenticationSucceeded    // Facebook Auth successful
 * MTFacebookAuthenticationFailed       // Facebook Auth failed (contains userInfo dict)
 * MTFacebookConnectionInterrupted      // Facebook Connection interrupted (contains userInfo dict, but not used yet)
 * MTFacebookConnectionReEstablished    // Facebook Connection re-established
 * MTFacebookAccessNotGranted           // Facebook access not granted by user
 * MTFacebookNewsItemsReceived          // Facebook items received (contains userInfo dict)
 * MTFacebookNewsItemsRequestFailed     // Facebook news item request failed (contains userInfo dict)
 * MTFacebookLogoutCompleted            // Facebook logout finished successfully
 *
 * MTAllServicesAuthenticationSucceeded // All services authenticated successfully
 * MTServiceNewsItemsReceived           // Any news items received, this notif is always sent before the service specific ones are sent (contains userInfo dict)
 * MTServiceNewsItemsRequestFailed      // Any news item request failed, always sent before the service specific ones (contains userInfo dict)
 *
 * Notification UserInfo dict Keys:
 *  
 * MTServiceAuthenticationErrorKey (MTTwitterAuthenticationFailed, MTFacebookAuthenticationFailed)
 * MTServiceTypeKey (MTTwitterNewsItemsReceived, MTTwitterNewsItemsRequestFailed, MTFacebookNewsItemsReceived, MTFacebookNewsItemsRequestFailed, MTServiceNewsItemsReceived, MTServiceNewsItemsRequestFailed)
 * MTServiceContentKey (MTTwitterNewsItemsReceived, MTFacebookNewsItemsReceived, MTServiceNewsItemsReceived)
 * MTServiceContentRequestFailedErrorKey (MTTwitterNewsItemsRequestFailed, MTFacebookNewsItemsRequestFailed, MTServiceNewsItemsRequestFailed)
 * MTServiceContentRequestFailedResponseKey (MTTwitterNewsItemsRequestFailed, MTFacebookNewsItemsRequestFailed, MTServiceNewsItemsRequestFailed)
 *
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    MTServiceConnectorManager *mgr = [MTServiceConnectorManager sharedServiceConnectorManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTwitterAuthenticated:) name:MTTwitterAuthenticationSucceeded object:mgr];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTwitterContentReceived:) name:MTTwitterNewsItemsReceived object:mgr];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFacebookAuthenticated:) name:MTFacebookAuthenticationSucceeded object:mgr];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFacebookContentReceived:) name:MTFacebookNewsItemsReceived object:mgr];
    
    // Pre-loaded from UserDefaults in final version
    // If nothing is in the User Defaults --> Show ServiceLogin Screen
    [mgr createAndConnectService:MTServiceTypeTwitter];
    [mgr createAndConnectService:MTServiceTypeFacebook];
    
    //[mgr logoutFromFacebook];
    
    [mgr authenticateServices];
    return YES;
}

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation {
    
    //TODO: Filter the sourceApplication, allow com.apple.mobilesafari & the FB App, do we need any other?
    return [[MTServiceConnectorManager sharedServiceConnectorManager] handleFacebookSSOCallback:url];
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
    
    //[[MTServiceConnectorManager sharedServiceConnectorManager] requestTwitterUserTimeline]; // !!!: TEST!!!
}

- (void)handleTwitterContentReceived:(NSNotification *)notification
{
    //NSLog(@"%@.%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), notification);
    
    NSLog(@"%@.%@: %@=[%@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd), MTServiceTypeKey, [[notification userInfo] objectForKey:MTServiceTypeKey]);
    
    //NSLog(@"%@.%@: %@=[%@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd), MTServiceContentKey, [[notification userInfo] objectForKey:MTServiceContentKey]);
}

- (void)handleFacebookAuthenticated:(NSNotification *)notification
{
    NSLog(@"%@.%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), notification);
    
    //[[MTServiceConnectorManager sharedServiceConnectorManager] requestFacebookUserTimeline]; // !!!: TEST!!!
}

- (void)handleFacebookContentReceived:(NSNotification *)notification
{
    //NSLog(@"%@.%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), notification);
    
    NSLog(@"%@.%@: %@=[%@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd), MTServiceTypeKey, [[notification userInfo] objectForKey:MTServiceTypeKey]);
    
    //NSLog(@"%@.%@: %@=[%@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd), MTServiceContentKey, [[notification userInfo] objectForKey:MTServiceContentKey]);
}


@end
