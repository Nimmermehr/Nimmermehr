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
#import "MTServiceContentType.h"
#import "MTNewsItem.h"
#import "UIImage+Utils.h"
#import "NSBundle+iStream.h"

// Twitter API Request overview: https://dev.twitter.com/docs/api

#define TwitterAPIDirectMessagesURL [NSURL URLWithString:@"http://api.twitter.com/1/direct_messages.json"]
#define TwitterAPIReplyMessagesURL  [NSURL URLWithString:@"http://api.twitter.com/1/statuses/mentions.json"]
#define TwitterAPIUserTimelineURL   [NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"]
#define TwitterAPIPublicTimelineURL [NSURL URLWithString:@"http://api.twitter.com/1/statuses/public_timeline.json"]
#define TwitterAPIUserPostsURL      [NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline.json"]
#define TwitterAPIUserFavouritesURL [NSURL URLWithString:@"http://api.twitter.com/1/favorites.json"]
#define TwitterAPIGetTweetByIdURL   [NSURL URLWithString:@"http://api.twitter.com/1/statuses/show.json"]

#define RegexExtractRecipients      @"@([a-zA-Z0-9-_])+"

static __strong UIImage *_serviceIcon;

@interface MTTwitterConnector (Private)
- (void)sendTwitterRequestWithURL:(MTServiceContentType *)serviceContentType;

- (NSURL *)getURLForContentType:(MTServiceContentType *)serviceContentType;

- (void)setTwitterAccounts:(NSArray *)twitterAccounts;

- (NSArray *)parseContent:(NSArray *)theTimeline contentType:(MTServiceContentType *)serviceContentType;

- (NSArray *)parseRecipients:(NSString *)content;

@end

@implementation MTTwitterConnector

@synthesize authenticated       = _authenticated;
@synthesize delegate            = _delegate;
@synthesize acStore             = _acStore;


+ (UIImage *)serviceIcon
{
    if (!_serviceIcon) {
        _serviceIcon = [NSBundle getServiceIconForService:MTServiceTypeTwitter]; 
    }
    
    return _serviceIcon;
}

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
        _acStore = [[ACAccountStore alloc] init];
        
        ACAccountType *type = [_acStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [_acStore requestAccessToAccountsWithType:type withCompletionHandler:^(BOOL accessGranted, NSError *terror) {
            
            if (accessGranted && !terror) {
                
                // Get all Twitter Accounts
                [self setTwitterAccounts:[_acStore accountsWithAccountType:type]];
                
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

- (void)requestUserPosts
{
    [self sendTwitterRequestWithURL:[MTServiceContentType getTwitterUserPostsContentType]];
}

- (void)requestUserTimeline
{
    [self sendTwitterRequestWithURL:[MTServiceContentType getTwitterUserTimelineContentType]];
}

- (void)requestPublicTimeline
{
    [self sendTwitterRequestWithURL:[MTServiceContentType getTwitterAnyContentType]];
}

- (void)requestReplyMessages
{
    [self sendTwitterRequestWithURL:[MTServiceContentType getTwitterUserWallContentType]];
}

- (void)requestDirectMessages
{
    [self sendTwitterRequestWithURL:[MTServiceContentType getTwitterUserMessagesContentType]];
}

- (void)requestConversationForTweet:(MTNewsItem *)initialTweet withCompletionHandler:(void(^)(NSArray *conversation, MTNewsItem *initialTweet))completionHandler
{
    __block MTNewsItem *theTweet = initialTweet;
    __block NSMutableArray *theConversation = [NSMutableArray arrayWithObject:initialTweet];
    __block NSDictionary *twitterContent = nil;
    __block BOOL isLoading = NO;
    __block BOOL hasReply = [theTweet repliedToMsgId] != nil;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    TWRequest *twitterReq = nil;
    
    while (hasReply) {
        
        if (!isLoading) {
            
            [params setObject:[theTweet repliedToMsgId] forKey:@"id"];
            twitterReq = [TWRequest requestWithURL:TwitterAPIGetTweetByIdURL parameters:params requestMethod:TWRequestMethodGET];
            
            [_delegate serviceDidStartLoading:[self serviceType]];
            
            isLoading = YES;
            
            [twitterReq performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                
                NSLog(@"STATUS CODE: %d", [urlResponse statusCode]);
                NSLog(@"TERROR: %@", error);
                NSLog(@"DATA: %@", responseData);
                
                isLoading = NO;
                
                if ([urlResponse statusCode] == 200) {
                    NSError *jsonParsingError = nil;
                    
                    twitterContent = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
                    
                    if (jsonParsingError) {
                        NSLog(@"JSON ERROR: %@", jsonParsingError);
                    }
                    
                    NSLog(@"PARSING FOR CONVERSATION: %@", twitterContent);
                    
                    theTweet = [[self parseContent:[NSArray arrayWithObject:twitterContent] contentType:nil] objectAtIndex:0]; // TODO: serviceContentType!!!!
                    
                    // Need to copy it, otherwise everything is fucked up...
                    // TODO: Implement hashCode, equals & copy in MTNewsItem
                    // http://robnapier.net/blog/implementing-nscopying-439
                    [theConversation addObject:[theTweet copy]];
                    
                    hasReply = [theTweet repliedToMsgId] != nil;
                } else {
                    NSLog(@"FFFAAAIIILLL!!!");
                    hasReply = NO;
                }
            }];
        }
    }
    
    NSLog(@"THE CONVERSATION: %@", theConversation);
    
    completionHandler((NSArray *)theConversation, initialTweet);
}

// TODO:
- (void)requestUserFavourites
{
    NSLog(@"%@.%@ NOT YET IMPLEMENTED :(", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)logout
{
    NSLog(@"%@.%@ NOT YET IMPLEMENTED :(", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end

@implementation MTTwitterConnector (Private)

- (void)sendTwitterRequestWithURL:(MTServiceContentType *)serviceContentType
{
    NSURL *theURL = [self getURLForContentType:serviceContentType];
    
    TWRequest *twitterReq = [TWRequest requestWithURL:theURL parameters:nil requestMethod:TWRequestMethodGET];
    
    // TODO: support multiple accounts
    [twitterReq setAccount:[_twitterAccounts objectAtIndex:0]];
    
    __block NSArray *twitterContent = nil;
    
    [_delegate serviceDidStartLoading:[self serviceType]];
    
    [twitterReq performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if ([urlResponse statusCode] == 200) {
            NSError *jsonParsingError = nil;
            
            twitterContent = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            
            NSLog(@"### CONTENT: %@", twitterContent);
            
            NSArray *parsedContent = [self parseContent:twitterContent contentType:serviceContentType];
            
            NSDictionary *newPosts = [NSDictionary dictionaryWithObjectsAndKeys:
                                      parsedContent,        MTServiceContentKey,
                                      [self serviceType],   MTServiceTypeKey,
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

- (NSArray *)parseContent:(NSArray *)theTimeline contentType:(MTServiceContentType *)serviceContentType
{
    NSMutableArray *newPosts = [NSMutableArray array];
    
    MTNewsItem *thePost = nil;
    
    NSDate *timestamp = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"]; // eg. Thu Apr 12 17:33:37 +0000 2012
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];	// <-- don't ask...
    
    UIImage *profilePic = nil;
    
    for (NSDictionary *tweet in theTimeline) {
        
        // TODO: use consts for the twitter keys
        // TODO: get all related @msgs to this tweet + count, also get share count
        // TODO: get all related/tagged/@recipients
        // No conversation api?? http://code.google.com/p/twitter-api/issues/detail?can=2&start=0&num=100&q=&colspec=ID%20Stars%20Type%20Bug%20Status%20Summary%20Opened%20Modified%20Component&groupby=&sort=&id=142
        
        timestamp = [formatter dateFromString:[tweet objectForKey:@"created_at"]];
        
        profilePic = [UIImage imageWithContentsOfURL:[NSURL URLWithString:[[tweet objectForKey:@"user"] objectForKey:@"profile_image_url_https"]]];
        
        thePost = [[MTNewsItem alloc] initWithAuthor:[[tweet objectForKey:@"user"] objectForKey:@"screen_name"]
                                             content:[tweet objectForKey:@"text"]
                                  serviceContentType:serviceContentType
                                      authorRealName:[[tweet objectForKey:@"user"] objectForKey:@"name"]
                                           timestamp:timestamp
                                  authorProfileImage:profilePic
                                adherentConversation:nil //TODO: 
                                  conversationLength:0 //TODO:
                                          shareCount:[[tweet objectForKey:@"retweet_count"] unsignedIntegerValue]
                                        taggedPeople:[self parseRecipients:[tweet objectForKey:@"text"]]
                                      repliedToMsgId:![[tweet objectForKey:@"in_reply_to_status_id_str"] isEqual:[NSNull null]] ? [tweet objectForKey:@"in_reply_to_status_id_str"] : nil
                   ];
        
        [newPosts addObject:thePost];
    }
    
    return newPosts;
}

- (NSArray *)parseRecipients:(NSString *)content
{
    NSArray *theArray = nil;
    
    NSError *terror = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:RegexExtractRecipients options:NSRegularExpressionCaseInsensitive error:&terror];
    
    if (!terror) {
        NSArray *matches = [regex matchesInString:content
                                          options:0
                                            range:NSMakeRange(0, [content length])
                            ];
        
        NSMutableArray *taggedPeople = [NSMutableArray array];
        
        for (NSTextCheckingResult *match in matches) {
            
            [taggedPeople addObject:[content substringWithRange:[match range]]];
            
        }
        
        theArray = (NSArray *)taggedPeople;
    } else {
        NSLog(@"REGEX TERROR: %@", terror);
    }
    
    return theArray;
}

- (NSURL *)getURLForContentType:(MTServiceContentType *)serviceContentType
{
    NSURL *theURL = nil;
    
    if ([[serviceContentType contentType] isEqualToString:MTServiceContentTypeUserTimeline]) {
        theURL = TwitterAPIUserTimelineURL;
    } else if ([[serviceContentType contentType] isEqualToString:MTServiceContentTypeUserMessages]) {
        theURL = TwitterAPIDirectMessagesURL;
    } else if ([[serviceContentType contentType] isEqualToString:MTServiceContentTypeUserPosts]) {
        theURL = TwitterAPIUserPostsURL;
    } else if ([[serviceContentType contentType] isEqualToString:MTServiceContentTypeUserWall]) {
        theURL = TwitterAPIReplyMessagesURL;
    } else if ([[serviceContentType contentType] isEqualToString:MTServiceContentTypeAny]) {
        theURL = TwitterAPIPublicTimelineURL;
    }
    
    return theURL;
}

@end
