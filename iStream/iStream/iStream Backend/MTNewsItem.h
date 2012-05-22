//
//  MTNewsItem.h
//  iStream
//
//  Created by Thomas Kober on 4/1/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>

// Encapsulates all relevant data of the service
// Add location, coords, creationdate, whatever else we need


@interface MTNewsItem : NSObject {
    // Template for User Posts
    MTNewsItem  *_template; // NSUserDefaults
}

@property (strong, nonatomic, readonly) NSString    *author;
@property (strong, nonatomic, readonly) NSString    *content;
@property (strong, nonatomic, readonly) NSString    *serviceType;
@property (strong, nonatomic, readonly) NSString    *authorRealName;
@property (strong, nonatomic, readonly) NSDate      *timestamp;
@property (strong, nonatomic, readonly) UIImage     *authorProfileImage;
@property (strong, nonatomic, readonly) NSArray     *adherentConversation;	// Comments (FB, G+)/@msgs (Twitter)
@property (nonatomic, readonly)         NSUInteger  conversationLength;
@property (nonatomic, readonly)         NSUInteger  shareCount;				// Likes (FB), +1 (G+), RT's (Twitter)
@property (strong, nonatomic, readonly) NSArray     *taggedPeople;			// tagged People/"with..." (FB), @recipients (Twitter)
@property (nonatomic)                   BOOL        unread;

- (id)initWithAuthor:(NSString *)theAuthor 
             content:(NSString *)theContent 
         serviceType:(NSString *)theServiceType 
      authorRealName:(NSString *)theAuthorRealName
           timestamp:(NSDate *)theTimestamp
  authorProfileImage:(UIImage *)theAuthorProfileImage
adherentConversation:(NSArray *)theAdherentConversation
  conversationLength:(NSUInteger)theConversationLength
          shareCount:(NSUInteger)theShareCount
        taggedPeople:(NSArray *)theTaggedPeople;

// When the User Posts a new message, we keep a Template with some of his data cached
// for convenience use by the frontend :)
- (id)initUserPostTemplateWithContent:(NSString *)theContent serviceType:(NSString *)theServiceType;


- (NSString *)description;
// TODO: isEqual + hashCode

@end
