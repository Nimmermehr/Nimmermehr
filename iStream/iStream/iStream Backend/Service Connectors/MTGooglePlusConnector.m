//
//  MTGooglePlusConnector.m
//  iStream
//
//  Created by Thomas Kober on 4/14/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTGooglePlusConnector.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "MTServiceConnectorDelegate.h"

#define GooglePlusKeychainItemName      @"Google+ OAuth2"
#define GooglePlusAPIUserTimelineURL    [NSURL URLWithString:@""]
#define GooglePlusAPIUserPostsURL       [NSURL URLWithString:@"https://www.googleapis.com/plus/v1/people/me/activities/public"]

@interface MTGooglePlusConnector (Private)
- (void)sendGooglePlusRequestWithURL:(NSURL *)reqURL;
@end

@implementation MTGooglePlusConnector

@synthesize authenticated       = _authenticated;
@synthesize autoPolling         = _autoPolling;
@synthesize autoPollingInterval = _autoPollingInterval;
@synthesize delegate            = _delegate;

- (id)init
{
    if ((self = [super init])) {
        _authenticated = NO;
        
        _viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:MTGooglePlusOAuthScope
                                                                     clientID:MTGooglePlusAppId 
                                                                 clientSecret:MTGooglePlusAppSecret
                                                             keychainItemName:GooglePlusKeychainItemName 
                                                                     delegate:self 
                                                             finishedSelector:@selector(viewController:finishedWithAuth:error:)
                           ];
    }
    
    return self;
}

- (void)authenticate
{
    // TODO: check first if the stored authToken is still valid
    [_delegate displayOAuth2UserDialog:[self serviceType] userDialog:_viewController];
}

- (NSString *)serviceType
{
    return MTServiceTypeGooglePlus;
}

- (void)logout
{
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:GooglePlusKeychainItemName];
    
    [GTMOAuth2ViewControllerTouch revokeTokenForGoogleAuthentication:_authToken];
    
    [_delegate serviceLogoutCompleted:[self serviceType]];
}

- (void)requestUserTimeline
{
    
}

- (void)requestUserWall
{
    
}

- (void)requestUserPosts
{
    [self sendGooglePlusRequestWithURL:GooglePlusAPIUserPostsURL];
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    
    [_delegate dismissOAuth2UserDialog:[self serviceType]];
    
    if (error) {
        // Authentication failed
        _authenticated = NO;
        
        if ([error code] == MTGooglePlusAccessNotGrantedErrorCode) {
            [_delegate accessNotGranted:[self serviceType]];
        } else {
            [_delegate serviceAuthenticationFailed:[self serviceType] errDict:[NSDictionary dictionaryWithObject:error forKey:MTServiceAuthenticationErrorKey]];
        }
        
    } else {
        // Authentication succeeded
        _authenticated = YES;
        
        _authToken = auth;
        
        [_delegate serviceAuthenticatedSuccessfully:[self serviceType]];
    }
}

@end

@implementation MTGooglePlusConnector (Private)

- (void)sendGooglePlusRequestWithURL:(NSURL *)reqURL
{
    // TODO: Create NSMutableURLRequest with URL & some Params
    // https://developers.google.com/+/api/
    
    [_authToken authorizeRequest:nil
         completionHandler:^(NSError *error) {
             if (error == nil) {
                 // the request has been authorized
             }
         }];
}

@end
