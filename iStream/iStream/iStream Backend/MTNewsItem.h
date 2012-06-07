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

@interface MTNewsItem : NSObject {
    
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
@property (nonatomic)                   BOOL                    unread;

- (id)initWithAuthor:(NSString *)author 
             content:(NSString *)content 
  serviceContentType:(MTServiceContentType *)serviceContentType
      authorRealName:(NSString *)authorRealName
           timestamp:(NSDate *)timestamp
  authorProfileImage:(UIImage *)authorProfileImage
adherentConversation:(NSArray *)adherentConversation
  conversationLength:(NSUInteger)conversationLength
          shareCount:(NSUInteger)shareCount
        taggedPeople:(NSArray *)taggedPeople
      repliedToMsgId:(NSString *)repliedToMsgId;

// When the User Posts a new message, we keep a Template with some of his data cached
// for convenience use by the frontend :)
- (id)initUserPostTemplateWithContent:(NSString *)content
                   serviceContentType:(MTServiceContentType *)serviceContentType;


- (NSString *)description;
// TODO: isEqual + hashCode + copy (implement NSCopying)

@end
