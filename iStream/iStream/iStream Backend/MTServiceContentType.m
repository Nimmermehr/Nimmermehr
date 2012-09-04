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

// twitter static factory singleton objects (PATTERN OVERUSE!!!!)
__strong static MTServiceContentType *_twitterUserPostsContentType      = nil;
__strong static MTServiceContentType *_twitterUserWallContentType       = nil;
__strong static MTServiceContentType *_twitterUserTimelineContentType   = nil;
__strong static MTServiceContentType *_twitterUserMessagesContentType   = nil;
__strong static MTServiceContentType *_twitterAnyContentType            = nil;

// facebook static factory singleton objects
__strong static MTServiceContentType *_facebookUserPostsContentType     = nil;
__strong static MTServiceContentType *_facebookUserWallContentType      = nil;
__strong static MTServiceContentType *_facebookUserTimelineContentType  = nil;
__strong static MTServiceContentType *_facebookUserMessagesContentType  = nil;
__strong static MTServiceContentType *_facebookAnyContentType           = nil;

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

+ (id)getFacebookUserPostsContentType
{
    if (!_facebookUserPostsContentType) {
        _facebookUserPostsContentType = [[MTServiceContentType alloc] initWithServiceType:MTServiceTypeFacebook contentType:MTServiceContentTypeUserPosts];
    }
    
    return _facebookUserPostsContentType;
}

+ (id)getFacebookUserTimelineContentType
{
    if (!_facebookUserTimelineContentType) {
        _facebookUserTimelineContentType = [[MTServiceContentType alloc] initWithServiceType:MTServiceTypeFacebook contentType:MTServiceContentTypeUserTimeline];
    }
    
    return _facebookUserTimelineContentType;
}

+ (id)getFacebookUserWallContentType
{
    if (!_facebookUserWallContentType) {
        _facebookUserWallContentType = [[MTServiceContentType alloc] initWithServiceType:MTServiceTypeFacebook contentType:MTServiceContentTypeUserWall];
    }
    
    return _facebookUserWallContentType;
}

+ (id)getFacebookUserMessagesContentType
{
    if (!_facebookUserMessagesContentType) {
        _facebookUserMessagesContentType = [[MTServiceContentType alloc] initWithServiceType:MTServiceTypeFacebook contentType:MTServiceContentTypeUserMessages];
    }
    
    return _facebookUserMessagesContentType;
}

+ (id)getFacebookAnyContentType
{
    if (!_facebookAnyContentType) {
        _facebookAnyContentType = [[MTServiceContentType alloc] initWithServiceType:MTServiceTypeFacebook contentType:MTServiceContentTypeAny];
    }
    
    return _facebookAnyContentType;
}

- (BOOL)isEqual:(id)object
{
    BOOL equals = NO;
    
    if (object) {
        if (self == object) {
            equals = YES;
        } else {
            if ([object isKindOfClass:[self class]]) {
                MTServiceContentType *other = (MTServiceContentType *)object;
                
                // Check serviceType && contentType
                if (
                        [[self serviceType] isEqualToString:[other serviceType]] &&
                        [[self contentType] isEqualToString:[other contentType]]
                    ) {
                            equals = YES;
                }
            }
        }
    }
    return equals;
}

- (NSUInteger)hash
{
    NSUInteger result = 17;
    
    result = 31 * result + [[self serviceType] hash];
    result = 31 * result + [[self contentType] hash];
    
    return result;
}

@end
