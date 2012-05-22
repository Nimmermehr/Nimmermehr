//
//  MTNewsItem.m
//  iStream
//
//  Created by Thomas Kober on 4/1/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTNewsItem.h"


@interface MTNewsItem ()
@property (strong, nonatomic, readwrite)	NSString    *author;
@property (strong, nonatomic, readwrite)	NSString    *content;
@property (strong, nonatomic, readwrite)	NSString    *serviceType;
@property (strong, nonatomic, readwrite)	NSString    *authorRealName;
@property (strong, nonatomic, readwrite)	NSDate      *timestamp;
@property (strong, nonatomic, readwrite)	UIImage     *authorProfileImage;
@property (strong, nonatomic, readwrite)	NSArray     *adherentConversation;
@property (nonatomic, readwrite)			NSUInteger  conversationLength;
@property (nonatomic, readwrite)			NSUInteger  shareCount;			
@property (strong, nonatomic, readwrite)	NSArray     *taggedPeople;		
@end


@implementation MTNewsItem
@synthesize  author
			,content
			,serviceType
			,authorRealName
			,timestamp
			,authorProfileImage
			,adherentConversation
			,conversationLength
			,shareCount
			,taggedPeople
			,unread;

#pragma mark Initialization / Deallocation

- (id)initWithAuthor:(NSString *)theAuthor 
             content:(NSString *)theContent 
         serviceType:(NSString *)theServiceType 
      authorRealName:(NSString *)theAuthorRealName
           timestamp:(NSDate *)theTimestamp
  authorProfileImage:(UIImage *)theAuthorProfileImage
adherentConversation:(NSArray *)theAdherentConversation
  conversationLength:(NSUInteger)theConversationLength
          shareCount:(NSUInteger)theShareCount
        taggedPeople:(NSArray *)theTaggedPeople {
	
    if ((self = [super init])) {
        self.author					= theAuthor;
        self.content				= theContent;
        self.serviceType			= theServiceType;
        self.authorRealName			= theAuthorRealName;
        self.timestamp				= theTimestamp;
        self.authorProfileImage		= theAuthorProfileImage;
        self.adherentConversation	= theAdherentConversation;
        self.conversationLength		= theConversationLength;
        self.shareCount				= theShareCount;
        self.taggedPeople			= theTaggedPeople;
        self.unread					= YES;
    }
    
    return self;
}

- (id)initUserPostTemplateWithContent:(NSString *)theContent serviceType:(NSString *)theServiceType {
    // TODO: Improve
    // TODO: What about Cross-Share among more services?
    return [self initWithAuthor:[_template author]
                        content:theContent 
                    serviceType:theServiceType 
                 authorRealName:[_template authorRealName] 
                      timestamp:nil 
             authorProfileImage:[_template authorProfileImage] 
           adherentConversation:nil 
             conversationLength:0 
                     shareCount:0 
                   taggedPeople:nil ];
}

#pragma mark Superclass overrides

// TODO: v-- improve this, it's quick and dirty and will only work for NSArrays
- (BOOL)isEqual:(id)object {
	BOOL equality = NO;
	
	if ([object isKindOfClass:self.class]) {
		MTNewsItem *otherItem = (MTNewsItem *)object;
		
		if (   [self.serviceType		isEqual:otherItem.serviceType]
			&& [self.content			isEqual:otherItem.content]
			&& [self.author				isEqual:otherItem.author]	)
			equality = YES;
	}
	
	return equality;
}

#pragma mark Debug methods

- (NSString *)description {
	NSMutableString *desc = [NSMutableString string];
	
	[desc appendFormat:@"%@:\n",NSStringFromClass(self.class)];
	[desc appendFormat:@" serviceType          [%@]\n",self.serviceType];
	[desc appendFormat:@" author               [%@]\n",self.author];
	[desc appendFormat:@" authorRealName       [%@]\n",self.authorRealName];
	[desc appendFormat:@" content              [%@]\n",self.content];
	[desc appendFormat:@" timestamp            [%@]\n",self.timestamp];
	[desc appendFormat:@" adherentConversation [%@]\n",self.adherentConversation];
	[desc appendFormat:@" conversationLength   [%ld]\n",self.conversationLength];
	[desc appendFormat:@" shareCount           [%ld]\n",self.shareCount];
	[desc appendFormat:@" taggedPeople         [%@]\n",self.taggedPeople];
	[desc appendFormat:@" unread               [%@]\n",BoolString(self.unread)];
	
    return (NSString *)desc;
}

@end
