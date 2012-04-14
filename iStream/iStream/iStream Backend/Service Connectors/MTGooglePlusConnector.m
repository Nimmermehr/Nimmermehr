//
//  MTGooglePlusConnector.m
//  iStream
//
//  Created by Thomas Kober on 4/14/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTGooglePlusConnector.h"

@implementation MTGooglePlusConnector

@synthesize authenticated       = _authenticated;
@synthesize autoPolling         = _autoPolling;
@synthesize autoPollingInterval = _autoPollingInterval;
@synthesize delegate            = _delegate;

- (id)init
{
    if ((self = [super init])) {
        _authenticated = NO;
    }
    
    return self;
}

- (void)authenticate
{
    
}

- (NSString *)serviceType
{
    return MTServiceTypeGooglePlus;
}

- (void)logout
{
    
}

- (void)requestUserTimeline
{
    
}

- (void)requestUserWall
{
    
}

- (void)requestUserPosts
{
    
}

@end
