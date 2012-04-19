//
//  MTNewsItem.m
//  TwitterConnect
//
//  Created by Thomas Kober on 4/1/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTNewsItem.h"

@implementation MTNewsItem

@synthesize author                  = _author;
@synthesize content                 = _content;
@synthesize serviceType             = _serviceType;
@synthesize authorRealName          = _authorRealName;
@synthesize timestamp               = _timestamp;
@synthesize authorProfileImage      = _authorProfileImage;
@synthesize adherentConversation    = _adherentConversation;
@synthesize conversationLength      = _conversationLength;
@synthesize shareCount              = _shareCount;
@synthesize taggedPeople            = _taggedPeople;
@synthesize unread                  = _unread;

- (id)initWithAuthor:(NSString *)author 
             content:(NSString *)content 
         serviceType:(NSString *)serviceType 
      authorRealName:(NSString *)authorRealName
           timestamp:(NSDate *)timestamp
  authorProfileImage:(UIImage *)authorProfileImage
adherentConversation:(NSArray *)adherentConversation
  conversationLength:(NSUInteger)conversationLength
          shareCount:(NSUInteger)shareCount
        taggedPeople:(NSArray *)taggedPeople
{
    if ((self = [super init])) {
        _author                 = author;
        _content                = content;
        _serviceType            = serviceType;
        _authorRealName         = authorRealName;
        _timestamp              = timestamp;
        _authorProfileImage     = authorProfileImage;
        _adherentConversation   = adherentConversation;
        _conversationLength     = conversationLength;
        _shareCount             = shareCount;
        _taggedPeople           = taggedPeople;
        _unread                 = YES;
    }
    
    return self;
}

- (id)initUserPostTemplateWithContent:(NSString *)content
                          serviceType:(NSString *)serviceType
{
    // TODO: Improve
    // TODO: What about Cross-Share among more services?
    return [self initWithAuthor:[_template author] 
                        content:content 
                    serviceType:serviceType 
                 authorRealName:[_template authorRealName] 
                      timestamp:nil 
             authorProfileImage:[_template authorProfileImage] 
           adherentConversation:nil 
             conversationLength:0 
                     shareCount:0 
                   taggedPeople:nil
     ];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"serviceType=[%@]\nauthor=[%@]\nauthorRealName=[%@]\ncontent=[%@]\nunread=[%@]\ntimestamp=[%@]\nadherentConversation=[%@]\nconversationLength=[%ld]\nshareCount=[%ld]\ntaggedPeople=[%@]", _serviceType, _author, _authorRealName, _content, _unread ? @"YES" : @"NO", _timestamp, _adherentConversation, _conversationLength, _shareCount, _taggedPeople];
}

@end
