//
//  MTFacebookConnector.m
//  iStream
//
//  Created by Thomas Kober on 4/13/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTFacebookConnector.h"
#import "MTServiceConnectorDelegate.h"
#import "MTNewsItem.h"

#define FacebookUserTimelinePath    @"me/home"
#define FacebookUserWallPath        @"me/feed"
#define FacebookUserPostsPath       @"me/posts"

@interface MTFacebookConnector (Private)
- (void)requestContentForGraphAPIPath:(NSString *)graphAPIPath;
- (NSArray *)parseDictionaryContent:(NSDictionary *)dictContent;
- (NSArray *)parseArrayContent:(NSArray *)arrContent;
- (NSArray *)parseStringContent:(NSString *)strContent;
- (NSArray *)parseNumberContent:(NSNumber *)nrContent;
@end

@implementation MTFacebookConnector

@synthesize authenticated       = _authenticated;
@synthesize autoPolling         = _autoPolling;
@synthesize autoPollingInterval = _autoPollingInterval;
@synthesize delegate            = _delegate;
@synthesize facebook            = _facebook;

- (id)init
{
    if ((self = [super init])) {
        
        _authenticated = NO;
        
        //TODO: prep macro to define whether we are premium or free app
        // paidapp
        // freeapp
        // testapp
        
        _facebook = [[Facebook alloc] initWithAppId:MTFacebookAppId urlSchemeSuffix:@"paidapp" andDelegate:self];
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
    } else { // We're already authenticated, notify everybody, good news, yay!!!
        _authenticated = YES;
        
        [_delegate serviceAuthenticatedSuccessfully:[self serviceType]];
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

- (void)logout
{
    [_facebook logout];
}

- (BOOL)handleSSOCallback:(NSURL *)url
{
    return [_facebook handleOpenURL:url];
}

#pragma mark FBSessionDelegate Implementation
// http://developers.facebook.com/docs/reference/iossdk/FBSessionDelegate/

- (void)fbSessionInvalidated
{
    // Send a Notif as well
    if (![_facebook isSessionValid]) {
        _authenticated = NO;
        
        [_delegate serviceConnectionInterrupted:[self serviceType] errDict:nil];
    }
    
    // Try to Extend Access Token in this case as well
    [_facebook extendAccessTokenIfNeeded];
}

- (void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
    if ([_facebook isSessionValid] && !_authenticated) {
        _authenticated = YES;
        
        [_delegate serviceConnectionReEstablished:[self serviceType]];
    }
}

- (void)fbDidLogout
{
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    
    [_delegate serviceLogoutCompleted:[self serviceType]];
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[_facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [_delegate serviceAuthenticatedSuccessfully:[self serviceType]];
    
}

#pragma mark FBRequestDelegate Implementation
// http://developers.facebook.com/docs/reference/iossdk/FBRequestDelegate/

- (void)requestLoading:(FBRequest *)request
{
    
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSDictionary *errDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self serviceType], MTServiceTypeKey,
                                error,              MTServiceContentRequestFailedErrorKey,
                                nil,                MTServiceContentRequestFailedResponseKey,
                                nil
                             ];
    
    [_delegate contentRequestFailed:errDict];
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSArray *theContent = nil;
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        theContent = [self parseDictionaryContent:result];
    } else if ([result isKindOfClass:[NSArray class]]) {
        theContent = [self parseArrayContent:result];
    } else if ([result isKindOfClass:[NSString class]]) {
        theContent = [self parseStringContent:result];
    } else if ([result isKindOfClass:[NSNumber class]]) {
        theContent = [self parseNumberContent:result];
    }
    
    NSDictionary *newPosts = [NSDictionary dictionaryWithObjectsAndKeys:
                                theContent,         MTServiceContentKey,
                                [self serviceType], MTServiceTypeKey,
                                nil
                              ];
    
    [_delegate contentReceived:newPosts];
}

- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
    
}

@end

#pragma mark Private Implementation
@implementation MTFacebookConnector (Private)

- (void)requestContentForGraphAPIPath:(NSString *)graphAPIPath
{
    [_facebook requestWithGraphPath:graphAPIPath andDelegate:self];
}

- (NSArray *)parseDictionaryContent:(NSDictionary *)dictContent
{
    NSMutableArray *newPosts = [NSMutableArray array];
    
    NSArray *theContent = [dictContent objectForKey:@"data"];
    
    MTNewsItem *newPost = nil;
    
    NSDate *timestamp = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-ddHH:mm:ssZZZZ"];
    
    UIImage *profilePic = nil;
    
    NSString *content = nil;
    
    for (NSDictionary *thePost in theContent) {
        
        timestamp = [formatter dateFromString:[thePost objectForKey:@"created_time"]];
        
        // TODO: profilePic, i guess we need to fetch the pic for the user id #argh
        
        // Check if FB Content is a Message or a Story (fucking FB clusterfuck)
        if ([thePost objectForKey:@"message"]) {
            // Message
            content = [thePost objectForKey:@"message"];
        } else {
            // Story
            content = [thePost objectForKey:@"story"];
        }
        
        newPost = [[MTNewsItem alloc] initWithAuthor:[[thePost objectForKey:@"from"] objectForKey:@"name"]
                                             content:content
                                         serviceType:[self serviceType] 
                                      authorRealName:[[thePost objectForKey:@"from"] objectForKey:@"name"]
                                           timestamp:timestamp
                                  authorProfileImage:profilePic
                                adherentConversation:nil //TODO: 
                                  conversationLength:0 //TODO:
                                          shareCount:0 //TODO:
                                        taggedPeople:nil//TODO:
                   ];
        
        [newPosts addObject:newPost];
    }
    
    return newPosts;
}

- (NSArray *)parseArrayContent:(NSArray *)arrContent
{
    return nil;
}

- (NSArray *)parseStringContent:(NSString *)strContent
{
    return nil;
}

- (NSArray *)parseNumberContent:(NSNumber *)nrContent
{
    return nil;
}

@end
