//
//  MTServiceContent.h
//  iStream
//
//  Created by Thomas Kober on 6/4/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTServiceContentType : NSObject {
    NSString    *_name;
    NSString    *_serviceType;
    NSString    *_contentType;
    BOOL        _shouldLoadContent;
}

@property (strong, nonatomic)   NSString    *name;
@property (strong, nonatomic)   NSString    *serviceType;
@property (strong, nonatomic)   NSString    *contentType; 
@property (nonatomic)           BOOL        shouldLoadContent;

- (id)initWithServiceType:(NSString *)serviceType;
- (id)initWithServiceType:(NSString *)serviceType contentType:(NSString *)contentType;
- (id)initWithServiceType:(NSString *)serviceType contentType:(NSString *)contentType shouldLoadContent:(BOOL)shouldLoadContent;

// twitter static factories
+ (id)getTwitterUserPostsContentType;
+ (id)getTwitterUserTimelineContentType;
+ (id)getTwitterUserWallContentType;
+ (id)getTwitterUserMessagesContentType;
+ (id)getTwitterAnyContentType;

+ (id)getFacebookUserPostsContentType;
+ (id)getFacebookUserTimelineContentType;
+ (id)getFacebookUserWallContentType;
+ (id)getFacebookUserMessagesContentType;
+ (id)getFacebookAnyContentType;

- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;
// TODO: description (I know, I'm lazy...)

@end
