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
#import "MTServiceContentType.h"
#import "NSBundle+iStream.h"
#import <FacebookSDK/FacebookSDK.h>

#define FacebookUserTimelinePath    @"me/home"
#define FacebookUserWallPath        @"me/feed"
#define FacebookUserPostsPath       @"me/posts"
#define FacebookUserLikedPages      @"me/likes"

static __strong UIImage *_serviceIcon;

NSString * const FBContentTypePhoto = @"photo";
NSString * const FBContentTypeLink = @"link";
NSString * const FBContentTypeStatus = @"status";

@interface MTFacebookConnector (Private)
- (void)requestContentForContentType:(MTServiceContentType *)serviceContentType;
- (NSString *)getGraphPathForServiceContentType:(MTServiceContentType *)serviceContentType;
- (NSArray *)parseContent:(NSDictionary *)dictContent serviceContentType:(MTServiceContentType *)serviceContentType;
- (NSArray *)parseAdherentConversation:(NSDictionary *)data;
- (NSString *)getItemContent:(NSDictionary *)rawPost;
- (NSArray *)parseTaggedPeople:(NSDictionary *)rawPost;

- (MTNewsItem *)parsePhoto:(NSDictionary *)rawPost serviceContentType:(MTServiceContentType *)serviceContentType;
- (MTNewsItem *)parseLink:(NSDictionary *)rawPost serviceContentType:(MTServiceContentType *)serviceContentType;
- (MTNewsItem *)parseStatus:(NSDictionary *)rawPost serviceContentType:(MTServiceContentType *)serviceContentType;
@end

@implementation MTFacebookConnector

@synthesize authenticated       = _authenticated;
@synthesize delegate            = _delegate;

+ (UIImage *)serviceIcon
{
    if (!_serviceIcon) {
        _serviceIcon = [NSBundle getServiceIconForService:MTServiceTypeFacebook];
    }
    
    return _serviceIcon;
}

- (id)init
{
    if ((self = [super init])) {
        
        _authenticated = NO;
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        
        // TODO: Check what more permissions we need
        NSArray *permissions = [NSArray arrayWithObjects:
                                @"user_likes",
                                @"read_stream",
                                @"user_photos",
                                @"user_status",
                                @"user_videos",
                                @"publish_stream",
                                nil
                                ];
        
        //TODO: prep macro to define whether we are premium or free app
        // paidapp
        // freeapp
        // testapp
        
        _session = [[FBSession alloc] initWithAppID:MTFacebookAppId permissions:permissions urlSchemeSuffix:@"paidapp" tokenCacheStrategy:nil]; // nil = default (@“FBAccessTokenInformationKey”)
        
        [FBSession setActiveSession:_session];
        /*
        NSLog(@"TOKEN: %@", [_session accessToken]);
        
        NSLog(@"SESSION STATE: %d", [_session state]);
        NSLog(@"##############################################");
        NSLog(@"FBSessionStateClosed: %d", FBSessionStateClosed);
        NSLog(@"FBSessionStateClosedLoginFailed: %d", FBSessionStateClosedLoginFailed);
        NSLog(@"FBSessionStateCreated: %d", FBSessionStateCreated);
        NSLog(@"FBSessionStateCreatedOpening: %d", FBSessionStateCreatedOpening);
        NSLog(@"FBSessionStateCreatedTokenLoaded: %d", FBSessionStateCreatedTokenLoaded);
        NSLog(@"FBSessionStateOpen: %d", FBSessionStateOpen);
        NSLog(@"FBSessionStateOpenTokenExtended: %d", FBSessionStateOpenTokenExtended);
         */
    }
    
    return self;
}

- (NSString *)serviceType
{
    return MTServiceTypeFacebook;
}

- (void)authenticate
{
    if (![_session isOpen]) {
        if ([_session state] == FBSessionStateCreatedTokenLoaded || [_session state] == FBSessionStateCreated) { // Any token here s(cached or new)?
            [_session openWithCompletionHandler:^(FBSession *session, FBSessionState state, NSError *terror) {
               
                if (!terror) {
                    
                    switch (state) {
                        case FBSessionStateOpen:
                            DLog(@"%@.%@ session opened successfully!", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
                            _authenticated = YES;
                            [_delegate serviceAuthenticatedSuccessfully:[self serviceType]];
                            break;
                            
                        case FBSessionStateClosed:
                        case FBSessionStateClosedLoginFailed:
                            DLog(@"%@.%@ failed! State=[%d]; Error=[%@]; Session=[%@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd), state, terror, session);
                            _authenticated = NO;
                            [_delegate serviceAuthenticationFailed:[self serviceType] errDict:[NSDictionary dictionaryWithObject:terror forKey:MTServiceAuthenticationErrorKey]];
                            break;
                            
                        default:
                            break;
                    }
                } else {
                    DLog(@"%@.%@ epic fail! Error=[%@]; Session=[%@]; State=[%d]", NSStringFromClass([self class]), NSStringFromSelector(_cmd), terror, session, state);
                    _authenticated = NO;
                    [_delegate serviceAuthenticationFailed:[self serviceType] errDict:[NSDictionary dictionaryWithObject:terror forKey:MTServiceAuthenticationErrorKey]];
                }
            }];
        } else {
            // TODO: Check the Docs again, in the meantime poll for a while and then fail
            DLog(@"%@.%@ token not yet loaded, polling for a bit then timing out...", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            
            NSInteger timeout = 100;
            NSInteger i = 0;
            
            // I know its kinda...erm...blocking the main thread...thats why there is a TODO in the else clause above...
            while (i <= timeout && [_session state] != FBSessionStateCreatedTokenLoaded) {
                i++;
            }
            
            if (i > timeout || [_session state] != FBSessionStateCreatedTokenLoaded) {
                // Fail here
                DLog(@"%@.%@ failed to load the created token. Clueless what to do now...", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
                _authenticated = NO;
                NSError *terror = [NSError errorWithDomain:@"FBAuthenticationFailedDomain" code:666 userInfo:[NSDictionary dictionaryWithObject:@"Failed to load the created access token!" forKey:NSUnderlyingErrorKey]];
                [_delegate serviceAuthenticationFailed:[self serviceType] errDict:[NSDictionary dictionaryWithObject:terror forKey:MTServiceAuthenticationErrorKey]];
            } else {
                // Retry here (a little bit of recursion shouldn't hurt too much)
                [self authenticate];
            }
        }
    } else {
        DLog(@"%@.%@ session already/still open. Nothing to do!", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
}

- (void)requestUserDetails
{
    
}

- (void)requestUserTimeline
{
    [self requestContentForContentType:[MTServiceContentType getFacebookUserTimelineContentType]];
}

- (void)requestUserWall
{
    [self requestContentForContentType:[MTServiceContentType getFacebookUserWallContentType]];
}

- (void)requestUserPosts
{
    [self requestContentForContentType:[MTServiceContentType getFacebookUserPostsContentType]];
}

- (void)logout
{
    [_session closeAndClearTokenInformation];
}

- (BOOL)handleSSOCallback:(NSURL *)url
{
    return [[FBSession activeSession] handleOpenURL:url];
}

@end

#pragma mark Private Implementation
@implementation MTFacebookConnector (Private)

// To get the User Details use [FBRequest requestForMe]
- (void)requestContentForContentType:(MTServiceContentType *)serviceContentType
{
    NSString *graphAPIPath = [self getGraphPathForServiceContentType:serviceContentType];
    
    FBRequest *request = [[FBRequest alloc] initWithSession:_session graphPath:graphAPIPath];
    
    [_delegate serviceDidStartLoading:[self serviceType]];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary *graphObj, NSError *terror) {
        
        if (!terror) {
            DLog(@"%@.%@ request completed successfully!", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            
            // Parse Content
            NSArray *parsedContent = [self parseContent:graphObj serviceContentType:serviceContentType];
            
            NSDictionary *newPosts = [NSDictionary dictionaryWithObjectsAndKeys:
                                        parsedContent,        MTServiceContentKey,
                                        [self serviceType],   MTServiceTypeKey,
                                        nil
                                      ];
            
            [_delegate contentReceived:newPosts];
            
        } else {
            DLog(@"%@.%@ content request for graphPath=[%@] failed! Error=[%@]!", NSStringFromClass([self class]), NSStringFromSelector(_cmd), graphAPIPath, terror);
            
            NSDictionary *errDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [self serviceType],         MTServiceTypeKey,
                                        terror,                     MTServiceContentRequestFailedErrorKey,
                                        [connection urlResponse],   MTServiceContentRequestFailedResponseKey,
                                        nil
                                     ];
            
            [_delegate contentRequestFailed:errDict];
        }
    }];
    
	// TODO: v-- maybe we should add a timeout to this thing later
	//while (request.state < kFBRequestStateComplete && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:.25]]);
}

- (NSArray *)parseContent:(NSDictionary *)dictContent serviceContentType:(MTServiceContentType *)serviceContentType
{
    NSMutableArray *newPosts = [NSMutableArray array];
    
    NSArray *theContent = [dictContent objectForKey:@"data"];
    
    MTNewsItem *newPost = nil;
    
    for (NSDictionary *thePost in theContent) {
        
        // Parse by type, #hooray
        if ([[thePost objectForKey:@"type"] isEqualToString:FBContentTypeStatus]) {
            newPost = [self parseStatus:thePost serviceContentType:serviceContentType];
        } else if ([[thePost objectForKey:@"type"] isEqualToString:FBContentTypePhoto]) {
            newPost = [self parsePhoto:thePost serviceContentType:serviceContentType];
        } else if ([[thePost objectForKey:@"type"] isEqualToString:FBContentTypeLink]) {
            newPost = [self parseLink:thePost serviceContentType:serviceContentType];
        }
        
        // TODO: profilePic, i guess we need to fetch the pic for the user id #argh
        [newPosts addObject:newPost];
    }
    
    return newPosts;
}

- (MTNewsItem *)parsePhoto:(NSDictionary *)rawPost serviceContentType:(MTServiceContentType *)serviceContentType
{
    NSDate *timestamp = [_dateFormatter dateFromString:[rawPost objectForKey:@"created_time"]];
    
    MTNewsItem *newPost = [[MTNewsItem alloc] initWithAuthor:[[rawPost objectForKey:@"from"] objectForKey:@"name"]
                                                     content:[self getItemContent:rawPost]
                                          serviceContentType:serviceContentType
                                              authorRealName:[[rawPost objectForKey:@"from"] objectForKey:@"name"]
                                                   timestamp:timestamp
                                          authorProfileImage:nil
                                        adherentConversation:nil //TODO:
                                          conversationLength:[[[rawPost objectForKey:@"comments"] objectForKey:@"count"] integerValue]
                                                  shareCount:[[[rawPost objectForKey:@"likes"] objectForKey:@"count"] integerValue]
                                                taggedPeople:[self parseTaggedPeople:rawPost]
                                              repliedToMsgId:nil//TODO:
                                                       links:nil
                           ];
    
    return newPost;
}

- (MTNewsItem *)parseLink:(NSDictionary *)rawPost serviceContentType:(MTServiceContentType *)serviceContentType
{
    NSDate *timestamp = [_dateFormatter dateFromString:[rawPost objectForKey:@"created_time"]];
    
    MTNewsItem *newPost = [[MTNewsItem alloc] initWithAuthor:[[rawPost objectForKey:@"from"] objectForKey:@"name"]
                                                     content:[self getItemContent:rawPost]
                                          serviceContentType:serviceContentType
                                              authorRealName:[[rawPost objectForKey:@"from"] objectForKey:@"name"]
                                                   timestamp:timestamp
                                          authorProfileImage:nil
                                        adherentConversation:nil //TODO:
                                          conversationLength:[[[rawPost objectForKey:@"comments"] objectForKey:@"count"] integerValue]
                                                  shareCount:[[[rawPost objectForKey:@"likes"] objectForKey:@"count"] integerValue]
                                                taggedPeople:[self parseTaggedPeople:rawPost]
                                              repliedToMsgId:nil//TODO:
                                                       links:nil
                           ];
    
    return newPost;
}

- (MTNewsItem *)parseStatus:(NSDictionary *)rawPost serviceContentType:(MTServiceContentType *)serviceContentType
{
    NSDate *timestamp = [_dateFormatter dateFromString:[rawPost objectForKey:@"created_time"]];
    
    NSArray *adherentConversation = nil;
    
    NSInteger commentCount = [[[rawPost objectForKey:@"comments"] objectForKey:@"count"] integerValue];
    
    if (commentCount > 0) { // da hell, we definitely need separate News Item Objects
        adherentConversation = [self parseAdherentConversation:[[rawPost objectForKey:@"comments"] objectForKey:@"data"]];
    }
        
    //ad profile pic, we may need to send a normal urlrequest to the url for the pic...muahahaha
    
    MTNewsItem *newPost = [[MTNewsItem alloc] initWithAuthor:[[rawPost objectForKey:@"from"] objectForKey:@"name"]
                                                     content:[self getItemContent:rawPost]
                                          serviceContentType:serviceContentType
                                              authorRealName:[[rawPost objectForKey:@"from"] objectForKey:@"name"]
                                                   timestamp:timestamp
                                          authorProfileImage:nil
                                        adherentConversation:adherentConversation
                                          conversationLength:commentCount
                                                  shareCount:[[[rawPost objectForKey:@"likes"] objectForKey:@"count"] integerValue]
                                                taggedPeople:[self parseTaggedPeople:rawPost]
                                              repliedToMsgId:nil//TODO:
                                                       links:nil
                           ];
    
    return newPost;
}

- (NSArray *)parseAdherentConversation:(NSDictionary *)data
{
    return nil;
}

- (NSString *)getGraphPathForServiceContentType:(MTServiceContentType *)serviceContentType
{
    NSString *graphAPIPath = nil;
    
    if ([[serviceContentType contentType] isEqualToString:MTServiceContentTypeUserPosts]) {
        graphAPIPath = FacebookUserPostsPath;
    } else if ([[serviceContentType contentType] isEqualToString:MTServiceContentTypeUserMessages]) {
        graphAPIPath = nil;//TODO: !!!!
    } else if ([[serviceContentType contentType] isEqualToString:MTServiceContentTypeUserTimeline]) {
        graphAPIPath = FacebookUserTimelinePath;
    } else if ([[serviceContentType contentType] isEqualToString:MTServiceContentTypeUserWall]) {
        graphAPIPath = FacebookUserWallPath;
    }
    
    return graphAPIPath;
}

- (NSArray *)parseTaggedPeople:(NSDictionary *)rawPost
{
    NSMutableArray *taggedPeople = [NSMutableArray array];
    
    for (NSDictionary *storyTag in [rawPost objectForKey:@"story_tags"]) {
        if ([[storyTag objectForKey:@"type"] isEqualToString:@"user"]) { // TODO: potentially create a MTServiceUser object which stores the important stuffs
            [taggedPeople addObject:[storyTag objectForKey:@"name"]];
        }
    }
    
    return (NSArray *)taggedPeople;
}

- (NSString *)getItemContent:(NSDictionary *)rawPost
{
    NSString *content = nil;
    
    if ([rawPost objectForKey:@"message"]) {
        content = [rawPost objectForKey:@"message"];
    } else {
        content = [rawPost objectForKey:@"story"];
    }
    
    return content;
}

@end