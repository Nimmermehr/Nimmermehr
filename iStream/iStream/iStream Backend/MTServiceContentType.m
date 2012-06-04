//
//  MTServiceContent.m
//  iStream
//
//  Created by Thomas Kober on 6/4/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTServiceContentType.h"

@implementation MTServiceContentType

@synthesize name                = _name;
@synthesize serviceType         = _serviceType;
@synthesize contentType         = _contentType;
@synthesize shouldLoadContent   = _shouldLoadContent;

// twitter static factories
__strong static MTServiceContentType *_twitterUserPostsContentType      = nil;
__strong static MTServiceContentType *_twitterUserWallContentType       = nil;
__strong static MTServiceContentType *_twitterUserTimelineContentType   = nil;
__strong static MTServiceContentType *_twitterUserMessagesContentType   = nil;
__strong static MTServiceContentType *_twitterAnyContentType            = nil;

- (id)initWithServiceType:(NSString *)serviceType
{
    return [self initWithServiceType:serviceType contentType:MTServiceContentTypeAny shouldLoadContent:YES];
}

- (id)initWithServiceType:(NSString *)serviceType contentType:(NSString *)contentType
{
    return [self initWithServiceType:serviceType contentType:contentType shouldLoadContent:YES];
}

- (id)initWithServiceType:(NSString *)serviceType contentType:(NSString *)contentType shouldLoadContent:(BOOL)shouldLoadContent
{
    if ((self = [super init])) {
        _serviceType = serviceType;
        _contentType = contentType;
        _shouldLoadContent = shouldLoadContent;
    }
    
    return self;
}

+ (id)getTwitterUserPostsContentType
{
    if (!_twitterUserPostsContentType) {
        _twitterUserPostsContentType = [[MTServiceContentType alloc] initWithServiceType:MTServiceTypeTwitter contentType:MTServiceContentTypeUserPosts];
    }
    
    return _twitterUserPostsContentType;
}

+ (id)getTwitterUserTimelineContentType
{
    if (!_twitterUserTimelineContentType) {
        _twitterUserTimelineContentType = [[MTServiceContentType alloc] initWithServiceType:MTServiceTypeTwitter contentType:MTServiceContentTypeUserTimeline];
    }
    
    return _twitterUserTimelineContentType;
}

+ (id)getTwitterUserWallContentType
{
    if (!_twitterUserWallContentType) {
        _twitterUserWallContentType = [[MTServiceContentType alloc] initWithServiceType:MTServiceTypeTwitter contentType:MTServiceContentTypeUserWall];
    }
    
    return _twitterUserWallContentType;
}

+ (id)getTwitterUserMessagesContentType
{
    if (!_twitterUserMessagesContentType) {
        _twitterUserMessagesContentType = [[MTServiceContentType alloc] initWithServiceType:MTServiceTypeTwitter contentType:MTServiceContentTypeUserMessages];
    }
    
    return _twitterUserMessagesContentType;
}

+ (id)getTwitterAnyContentType
{
    if (!_twitterAnyContentType) {
        _twitterAnyContentType = [[MTServiceContentType alloc] initWithServiceType:MTServiceTypeTwitter contentType:MTServiceContentTypeAny];
    }
    
    return _twitterAnyContentType;
}


@end
