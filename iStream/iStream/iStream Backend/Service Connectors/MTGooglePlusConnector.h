//
//  MTGooglePlusConnector.h
//  iStream
//
//  Created by Thomas Kober on 4/14/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTServiceConnector.h"

@class GTMOAuth2ViewControllerTouch;
@class GTMOAuth2Authentication;
@protocol MTServiceConnectorDelegate;

@interface MTGooglePlusConnector : NSObject<MTServiceConnector> {
    
    BOOL                                _authenticated;
    BOOL                                _autoPolling;
    float                               _autoPollingInterval;
    GTMOAuth2ViewControllerTouch        *_viewController;
    __strong GTMOAuth2Authentication    *_authToken;
    
}

@property (nonatomic, readonly) BOOL                            authenticated;
@property (nonatomic)           BOOL                            autoPolling;
@property (nonatomic)           float                           autoPollingInterval;
@property (weak, nonatomic)     id<MTServiceConnectorDelegate>  delegate;

- (void)authenticate;
- (NSString *)serviceType;

- (void)logout;

- (void)requestUserTimeline;
- (void)requestUserWall;
- (void)requestUserPosts;

@end
