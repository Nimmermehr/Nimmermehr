//
//  MTFacebookConnector.h
//  iStream
//
//  Created by Thomas Kober on 4/13/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTServiceConnector.h"

@protocol MTServiceConnectorDelegate;
@class FBSession;

@interface MTFacebookConnector : NSObject <MTServiceConnector> {
    
    BOOL            _authenticated;
    FBSession       *_session;
    NSDateFormatter *_dateFormatter;
}

@property (nonatomic, readonly) BOOL                            authenticated;
@property (weak, nonatomic)     id<MTServiceConnectorDelegate>  delegate;

- (void)authenticate;
- (NSString *)serviceType;

- (BOOL)handleSSOCallback:(NSURL *)url;

- (void)requestUserDetails;

- (void)requestUserTimeline;
- (void)requestUserWall;
- (void)requestUserPosts;

@end
