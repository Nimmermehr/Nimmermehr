//
//  MTTwitterConnector.h
//  TwitterConnect
//
//  Created by Thomas Kober on 3/30/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "MTServiceConnector.h"

@protocol MTServiceConnectorDelegate;

@interface MTTwitterConnector : NSObject <MTServiceConnector> {
    
    BOOL    _authenticated;
    NSArray *_twitterAccounts;
    BOOL    _autoPolling;
    float   _autoPollingInterval;
}

// Handle the Polling of checking for new Posts

@property(nonatomic, readonly)  BOOL                            authenticated;
@property(nonatomic, weak)      id<MTServiceConnectorDelegate>  delegate;
@property(nonatomic)            BOOL                            autoPolling;
@property(nonatomic)            float                           autoPollingInterval;

- (void)requestUserTimeline;
- (void)requestPublicTimeline;
- (void)requestReplyMessages;
- (void)requestDirectMessages;
- (void)requestUserPosts;

- (void)authenticate;

- (NSString *)serviceType;

@end
