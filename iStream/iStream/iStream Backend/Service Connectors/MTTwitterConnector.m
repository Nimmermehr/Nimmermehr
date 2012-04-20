//
//  MTTwitterConnector.m
//  TwitterConnect
//
//  Created by Thomas Kober on 3/30/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTTwitterConnector.h"
#import "TWRequest+Utils.h"
#import "MTServiceConnectorDelegate.h"
#import "MTNewsItem.h"
#import "UIImage+Utils.h"

// Twitter API Request overview: https://dev.twitter.com/docs/api

#define TwitterAPIDirectMessagesURL [NSURL URLWithString:@"http://api.twitter.com/1/statuses/direct_messages.json"]
#define TwitterAPIReplyMessagesURL  [NSURL URLWithString:@"http://api.twitter.com/1/statuses/mentions.json"]
#define TwitterAPIUserTimelineURL   [NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"]
#define TwitterAPIPublicTimelineURL [NSURL URLWithString:@"http://api.twitter.com/1/statuses/public_timeline.json"]

@interface MTTwitterConnector (Private)
- (void)sendTwitterRequestWithURL:(NSURL *)theURL;

- (void)setTwitterAccounts:(NSArray *)twitterAccounts;

- (NSArray *)parseContent:(NSArray *)theTimeline;
@end

@implementation MTTwitterConnector

@synthesize authenticated       = _authenticated;
@synthesize delegate            = _delegate;
@synthesize autoPolling         = _autoPolling;
@synthesize autoPollingInterval = _autoPollingInterval;

- (id)init
{
    if ((self = [super init])) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAccountStoreChanged:) name:ACAccountStoreDidChangeNotification object:nil];
                
        _twitterAccounts = [[NSArray alloc] init];
        
        _authenticated = NO;
        
        // TODO: setup autopolling
    }
    
    return self;
}

- (void)authenticate
{
    if (!_authenticated) {
        ACAccountStore *store = [[ACAccountStore alloc] init];
        
        ACAccountType *type = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [store requestAccessToAccountsWithType:type withCompletionHandler:^(BOOL accessGranted, NSError *terror) {
            
            if (accessGranted && !terror) {
                
                // Get all Twitter Accounts
                [self setTwitterAccounts:[store accountsWithAccountType:type]];
                
                _authenticated = YES;
                
                [_delegate serviceAuthenticatedSuccessfully:[self serviceType]];
                
            } else {
                
                _authenticated = NO;
                
                if (!accessGranted) {
                    [_delegate accessNotGranted:[self serviceType]];
                }
                
                if (terror) {
                    [_delegate serviceAuthenticationFailed:[self serviceType] errDict:[NSDictionary dictionaryWithObject:terror forKey:MTServiceAuthenticationErrorKey]];
                }
            }
            
        }];
    }
}

- (NSString *)serviceType
{
    return MTServiceTypeTwitter;
}

- (void)handleAccountStoreChanged:(NSNotification *)aNotification
{
    // Check if we are still able to tweet, if not send notifications or similiar
    if (![TWTweetComposeViewController canSendTweet]) {
        // Notify everybody 
    }
}

- (void)requestUserTimeline
{
    [self sendTwitterRequestWithURL:TwitterAPIUserTimelineURL];
}

- (void)requestPublicTimeline
{
    [self sendTwitterRequestWithURL:TwitterAPIPublicTimelineURL];
}

- (void)requestReplyMessages
{
    [self sendTwitterRequestWithURL:TwitterAPIReplyMessagesURL];
}

- (void)requestDirectMessages
{
    [self sendTwitterRequestWithURL:TwitterAPIDirectMessagesURL];
}

- (void)logout
{
    NSLog(@"%@.%@ NOT YET IMPLEMENTED :(", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end

@implementation MTTwitterConnector (Private)

- (void)sendTwitterRequestWithURL:(NSURL *)theURL
{
    TWRequest *twitterReq = [TWRequest requestWithURL:theURL parameters:nil requestMethod:TWRequestMethodGET];
    
    // TODO: support multiple accounts
    [twitterReq setAccount:[_twitterAccounts objectAtIndex:0]];
    
    __block NSArray *twitterContent = nil;
    
    [twitterReq performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if ([urlResponse statusCode] == 200) {
            NSError *jsonParsingError = nil;
            
            twitterContent = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            
            NSDictionary *newPosts = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [self parseContent:twitterContent],   MTServiceContentKey,
                                      [self serviceType],                   MTServiceTypeKey,
                                      nil
                                      ];
            
            [_delegate contentReceived:newPosts];
            
        } else {
            // FAIL
            NSDictionary *errDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [self serviceType], MTServiceTypeKey,
                                        error,              MTServiceContentRequestFailedErrorKey,
                                        urlResponse,        MTServiceContentRequestFailedResponseKey,
                                        nil
                                     ];
            
            [_delegate contentRequestFailed:errDict];
        }
        
    }];
}

- (void)setTwitterAccounts:(NSArray *)twitterAccounts
{
    _twitterAccounts = twitterAccounts;
}

- (NSArray *)parseContent:(NSArray *)theTimeline
{
    NSMutableArray *newPosts = [NSMutableArray array];
    
    MTNewsItem *thePost = nil;
    
    NSDate *timestamp = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"]; // eg. Thu Apr 12 17:33:37 +0000 2012
    
    UIImage *profilePic = nil;
    
    for (NSDictionary *tweet in theTimeline) {
        
        // TODO: use consts for the twitter keys
        // TODO: get all related @msgs to this tweet + count, also get share count
        // TODO: get all related/tagged/@recipients
        timestamp = [formatter dateFromString:[tweet objectForKey:@"created_at"]];
        
        profilePic = [UIImage imageWithContentsOfURL:[NSURL URLWithString:[[tweet objectForKey:@"user"] objectForKey:@"profile_image_url_https"]]];
        
        thePost = [[MTNewsItem alloc] initWithAuthor:[[tweet objectForKey:@"user"] objectForKey:@"screen_name"]
                                             content:[tweet objectForKey:@"text"]
                                         serviceType:[self serviceType] 
                                      authorRealName:[[tweet objectForKey:@"user"] objectForKey:@"name"]
                                           timestamp:timestamp
                                  authorProfileImage:profilePic
                                adherentConversation:nil //TODO: 
                                  conversationLength:0 //TODO:
                                          shareCount:0 //TODO:
                                        taggedPeople:nil//TODO:
                   ];
        
        [newPosts addObject:thePost];
    }
    
    return newPosts;
}

@end
