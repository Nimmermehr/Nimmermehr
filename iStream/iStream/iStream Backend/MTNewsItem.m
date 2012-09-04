//
//  MTNewsItem.m
//  iStream
//
//  Created by Thomas Kober on 4/1/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTNewsItem.h"


@interface MTNewsItem ()
@property (strong, nonatomic, readwrite)	NSString    			*author;
@property (strong, nonatomic, readwrite)	NSString    			*content;
@property (strong, nonatomic, readwrite)	MTServiceContentType	*serviceContentType;
@property (strong, nonatomic, readwrite)	NSString   				*authorRealName;
@property (strong, nonatomic, readwrite)	NSDate      			*timestamp;
@property (strong, nonatomic, readwrite)	UIImage     			*authorProfileImage;
@property (strong, nonatomic, readwrite)	NSArray     			*adherentConversation;
@property (nonatomic, readwrite)			NSUInteger  			conversationLength;
@property (nonatomic, readwrite)			NSUInteger  			shareCount;			
@property (strong, nonatomic, readwrite)	NSArray     			*taggedPeople;	
@property (strong, nonatomic, readwrite)    NSString                *repliedToMsgId;
@property (strong, nonatomic, readwrite)    NSArray                 *links;
@end


@implementation MTNewsItem
@synthesize  author
,content
,serviceContentType
,authorRealName
,timestamp
,authorProfileImage
,adherentConversation
,conversationLength
,shareCount
,taggedPeople
,unread
,repliedToMsgId
,links;

#pragma mark Initialization / Deallocation

- (id)initWithAuthor:(NSString *)theAuthor 
             content:(NSString *)theContent 
  serviceContentType:(MTServiceContentType *)theServiceContentType 
      authorRealName:(NSString *)theAuthorRealName
           timestamp:(NSDate *)theTimestamp
  authorProfileImage:(UIImage *)theAuthorProfileImage
adherentConversation:(NSArray *)theAdherentConversation
  conversationLength:(NSUInteger)theConversationLength
          shareCount:(NSUInteger)theShareCount
        taggedPeople:(NSArray *)theTaggedPeople
      repliedToMsgId:(NSString *)theRepliedToMsgId
               links:(NSArray *)theLinks
{
    
    if ((self = [super init])) {
        self.author					= theAuthor;
        self.content				= theContent;
        self.serviceContentType		= theServiceContentType;
        self.authorRealName			= theAuthorRealName;
        self.timestamp				= theTimestamp;
        self.authorProfileImage		= theAuthorProfileImage;
        self.adherentConversation	= theAdherentConversation;
        self.conversationLength		= theConversationLength;
        self.shareCount				= theShareCount;
        self.taggedPeople			= theTaggedPeople;
        self.repliedToMsgId         = theRepliedToMsgId;
        self.links                  = theLinks;
        self.unread					= YES;
    }
    
    return self;
}

- (id)initUserPostTemplateWithContent:(NSString *)theContent serviceContentType:(MTServiceContentType *)theServiceContentType {
    // TODO: Improve
    // TODO: What about Cross-Share among more services?
    // TODO: Support more than 1 account per service for sharing
    return [self initWithAuthor:[_template author]
                        content:theContent 
             serviceContentType:theServiceContentType 
                 authorRealName:[_template authorRealName] 
                      timestamp:nil 
             authorProfileImage:[_template authorProfileImage] 
           adherentConversation:nil 
             conversationLength:0 
                     shareCount:0 
                   taggedPeople:nil
                 repliedToMsgId:nil
                          links:nil
            ];
}

#pragma mark Superclass overrides

// TODO: v-- improve this, it's quick and dirty and will only work for NSArrays
- (BOOL)isEqual:(id)object {
	BOOL equality = NO;
    
	if ([object isKindOfClass:self.class]) {
		MTNewsItem *otherItem = (MTNewsItem *)object;
        
		if (   [self.serviceContentType	isEqual:otherItem.serviceContentType]
			&& [self.content			isEqual:otherItem.content]
			&& [self.author				isEqual:otherItem.author]	)
			equality = YES;
	}
    
	return equality;
}

- (NSComparisonResult)compare:(MTNewsItem *)other
{
    // So far only comparing the timestamps, do we need more?
    return [[self timestamp] compare:[other timestamp]];
}

- (id)copyWithZone:(NSZone *)zone
{
    // We only need a shallow copy, as all members are either readonly or primitive
    // TODO: Check twice if we really only need a shallow copy (I'm thinking Twitter & adherentConversations)
    return [super copy];
}

#pragma mark Debug methods

- (NSString *)description {
	NSMutableString *desc = [NSMutableString string];
    
	[desc appendFormat:@"%@:\n",NSStringFromClass(self.class)];
	[desc appendFormat:@" serviceContentType   [%@]\n",self.serviceContentType];
	[desc appendFormat:@" author               [%@]\n",self.author];
	[desc appendFormat:@" authorRealName       [%@]\n",self.authorRealName];
	[desc appendFormat:@" content              [%@]\n",self.content];
	[desc appendFormat:@" timestamp            [%@]\n",self.timestamp];
	[desc appendFormat:@" adherentConversation [%@]\n",self.adherentConversation];
	[desc appendFormat:@" conversationLength   [%ld]\n",(unsigned long)self.conversationLength];
	[desc appendFormat:@" shareCount           [%ld]\n",(unsigned long)self.shareCount];
	[desc appendFormat:@" taggedPeople         [%@]\n",self.taggedPeople];
    [desc appendFormat:@" links                [%@]\n",self.links];
	[desc appendFormat:@" unread               [%@]\n",BoolString(self.unread)];
    
    return (NSString *)desc;
}

@end