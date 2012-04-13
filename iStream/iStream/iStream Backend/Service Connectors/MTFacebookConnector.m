//
//  MTFacebookConnector.m
//  iStream
//
//  Created by Thomas Kober on 4/13/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTFacebookConnector.h"
#import "MTServiceConnectorDelegate.h"

#define FacebookUserTimelinePath    @"me/home"
#define FacebookUserWallPath        @"me/feed"
#define FacebookUserPostsPath       @"me/posts"

@interface MTFacebookConnector (Private)
- (void)requestContentForGraphAPIPath:(NSString *)graphAPIPath;
@end

@implementation MTFacebookConnector

@synthesize authenticated       = _authenticated;
@synthesize autoPolling         = _autoPolling;
@synthesize autoPollingInterval = _autoPollingInterval;
@synthesize delegate            = _delegate;

- (id)init
{
    if ((self = [super init])) {
        
        _authenticated = NO;
        _facebook = [[Facebook alloc] initWithAppId:MTFacebookAppId andDelegate:self];
    }
    
    return self;
}

- (NSString *)serviceType
{
    return MTServiceTypeFacebook;
}

- (void)authenticate
{
    // Facebook SSO, check if access tokens are already there, otherwise request some
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        
        [_facebook setAccessToken:[defaults objectForKey:@"FBAccessTokenKey"]];
        [_facebook setExpirationDate:[defaults objectForKey:@"FBExpirationDateKey"]];
    }
    
    // TODO: Check what more permissions we need
    NSArray *permissions = [NSArray arrayWithObjects:
                                @"user_likes", 
                                @"read_stream",
                                @"user_photos",
                                @"user_status",
                                @"user_videos",
                                nil
                            ];
    
    if (![_facebook isSessionValid]) {
        [_facebook authorize:permissions];
    }
}

- (void)requestUserTimeline
{
    [self requestContentForGraphAPIPath:FacebookUserTimelinePath];
}

- (void)requestUserWall
{
    [self requestContentForGraphAPIPath:FacebookUserWallPath];
}

- (void)requestUserPosts
{
    [self requestContentForGraphAPIPath:FacebookUserPostsPath];
}

// Access request Callback
- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation {
    
    return [_facebook handleOpenURL:url]; 
}

#pragma mark FBSessionDelegate Implementation
// http://developers.facebook.com/docs/reference/iossdk/FBSessionDelegate/

- (void)fbSessionInvalidated
{
    // Send a Notif as well
    if (![_facebook isSessionValid]) {
        _authenticated = NO;
    }
    
    // Try to Extend Access Token in this case as well
    [_facebook extendAccessTokenIfNeeded];
}

- (void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
    if ([_facebook isSessionValid]) {
        _authenticated = YES;
    }
}

- (void)fbDidLogout
{
    
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    // If cancelled == YES --> access not granted

    _authenticated = NO;
    
    if (cancelled) {
        [_delegate accessNotGranted:[self serviceType]];
    } else {
        [_delegate serviceAuthenticationFailed:[self serviceType] errDict:nil];
    }
}

- (void)fbDidLogin
{
    _authenticated = YES;
    
    [_delegate serviceAuthenticatedSuccessfully:[self serviceType]];
    
}

#pragma mark FBRequestDelegate Implementation
// TODO:
@end

#pragma mark Private Implementation
@implementation MTFacebookConnector (Private)

- (void)requestContentForGraphAPIPath:(NSString *)graphAPIPath
{
    [_facebook requestWithGraphPath:graphAPIPath andDelegate:self];
}

@end
