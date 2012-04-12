//
//  MTNewsItem.m
//  TwitterConnect
//
//  Created by Thomas Kober on 4/1/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTNewsItem.h"

@implementation MTNewsItem

@synthesize author              = _author;
@synthesize content             = _content;
@synthesize serviceType         = _serviceType;
@synthesize authorRealName      = _authorRealName;
@synthesize timestamp           = _timestamp;
@synthesize authorProfileImage  = _authorProfileImage;
@synthesize unread              = _unread;

- (id)initWithAuthor:(NSString *)author 
             content:(NSString *)content 
         serviceType:(NSString *)serviceType 
      authorRealName:(NSString *)authorRealName
           timestamp:(NSDate *)timestamp
  authorProfileImage:(UIImage *)authorProfileImage
{
    if ((self = [super init])) {
        _author             = author;
        _content            = content;
        _serviceType        = serviceType;
        _authorRealName     = authorRealName;
        _timestamp          = timestamp;
        _authorProfileImage = authorProfileImage;
        _unread             = YES;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"serviceType=[%@]\nauthor=[%@]\nauthorRealName=[%@]\ncontent=[%@]\nunread=[%@]\ntimestamp=[%@]", _serviceType, _author, _authorRealName, _content, _unread ? @"YES" : @"NO", _timestamp];
}

@end
