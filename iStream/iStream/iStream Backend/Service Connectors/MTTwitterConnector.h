//
//  MTTwitterConnector.h
//  iStream
//
//  Created by Thomas Kober on 3/30/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "MTServiceConnector.h"

@protocol MTServiceConnectorDelegate;
@class MTNewsItem;

@interface MTTwitterConnector : NSObject <MTServiceConnector> {
    
    BOOL            _authenticated;
    NSArray         *_twitterAccounts;
}
@property(nonatomic)			ACAccountStore *acStore;

// Handle the Polling of checking for new Posts

@property(nonatomic, readonly)  BOOL                            authenticated;
@property(nonatomic, weak)      id<MTServiceConnectorDelegate>  delegate;
@property(nonatomic, strong)	ACAccountStore                  *acStore;

- (void)requestUserTimeline;
- (void)requestPublicTimeline;
- (void)requestReplyMessages;
- (void)requestDirectMessages;
- (void)requestUserPosts;

- (void)requestConversationForTweet:(MTNewsItem *)initialTweet withCompletionHandler:(void(^)(NSArray *conversation, MTNewsItem *initialTweet))completionHandler;

- (void)authenticate;

- (NSString *)serviceType;

@end
