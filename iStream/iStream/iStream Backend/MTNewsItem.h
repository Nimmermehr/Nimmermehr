//
//  MTNewsItem.h
//  iStream
//
//  Created by Thomas Kober on 4/1/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTServiceContentType.h"

// Encapsulates all relevant data of the service
// Add location, coords, creationdate, whatever else we need

@interface MTNewsItem : NSObject <NSCopying> {
    
    // Template for User Posts
    MTNewsItem              *_template; // NSUserDefaults
}

@property (strong, nonatomic, readonly) NSString                *author;
@property (strong, nonatomic, readonly) NSString                *content;
@property (strong, nonatomic, readonly) MTServiceContentType    *serviceContentType;
@property (strong, nonatomic, readonly) NSString                *authorRealName;
@property (strong, nonatomic, readonly) NSDate                  *timestamp;
@property (strong, nonatomic, readonly) UIImage                 *authorProfileImage;
@property (strong, nonatomic, readonly) NSArray                 *adherentConversation; // Comments (FB, G+)/@msgs (Twitter)
@property (nonatomic, readonly)         NSUInteger              conversationLength;
@property (nonatomic, readonly)         NSUInteger              shareCount; // Likes (FB), +1 (G+), RT's (Twitter)
@property (strong, nonatomic, readonly) NSArray                 *taggedPeople;// tagged People/"with..." (FB), @recipients (Twitter)
@property (strong, nonatomic, readonly) NSString                *repliedToMsgId;
@property (strong, nonatomic, readonly) NSArray                 *links;
@property (nonatomic)                   BOOL                    unread;

// TODO: an own array for people who like sth???
// TODO: Shall we create own MTNewsItem subclasses for all Types???
//          getting a bit awkward w/ all the service specific shites....

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
               links:(NSArray *)theLinks;

// When the User Posts a new message, we keep a Template with some of his data cached
// for convenience use by the frontend :)
- (id)initUserPostTemplateWithContent:(NSString *)content
                   serviceContentType:(MTServiceContentType *)serviceContentType;


- (NSString *)description;
// TODO: isEqual + hashCode + copy (implement NSCopying)

- (id)copyWithZone:(NSZone *)zone;

- (NSComparisonResult)compare:(MTNewsItem *)other;

@end