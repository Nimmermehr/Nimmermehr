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
    
    BOOL            _authenticated;
    Facebook        *_facebook;
}

@property (nonatomic, readonly) BOOL                            authenticated;
@property (weak, nonatomic)     id<MTServiceConnectorDelegate>  delegate;
@property (strong, nonatomic)   Facebook                        *facebook;

- (void)authenticate;
- (NSString *)serviceType;

- (BOOL)handleSSOCallback:(NSURL *)url;

- (void)requestUserTimeline;
- (void)requestUserWall;
- (void)requestUserPosts;

@end
