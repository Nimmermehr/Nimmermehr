//
//  MTFacebookConnector.h
//  iStream
//
//  Created by Thomas Kober on 4/13/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTServiceConnector.h"
#import "FBConnect.h"

@protocol MTServiceConnectorDelegate;

@interface MTFacebookConnector : NSObject <MTServiceConnector, FBSessionDelegate, FBRequestDelegate> {
    
    BOOL        _authenticated;
    BOOL        _autoPolling;
    float       _autoPollingInterval;
    Facebook    *_facebook;
}

@property (nonatomic, readonly) BOOL                            authenticated;
@property (nonatomic)           BOOL                            autoPolling;
@property (nonatomic)           float                           autoPollingInterval;
@property (weak, nonatomic)     id<MTServiceConnectorDelegate>  delegate;

- (void)authenticate;
- (NSString *)serviceType;

- (void)requestUserTimeline;
- (void)requestUserWall;
- (void)requestUserPosts;

@end
