//
//  MTNewsItem.h
//  TwitterConnect
//
//  Created by Thomas Kober on 4/1/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>

// Encapsulates all relevant data of the service
// Add location, coords, creationdate, whatever else we need

@interface MTNewsItem : NSObject {

@private
    NSString    *_author;
    NSString    *_content;
    NSString    *_serviceType;
    NSString    *_authorRealName;
    NSDate      *_timestamp;
    BOOL        _unread;
}

@property (strong, nonatomic, readonly) NSString    *author;
@property (strong, nonatomic, readonly) NSString    *content;
@property (strong, nonatomic, readonly) NSString    *serviceType;
@property (strong, nonatomic, readonly) NSString    *authorRealName;
@property (strong, nonatomic, readonly) NSDate      *timestamp;
@property (nonatomic)                   BOOL        unread;

- (id)initWithAuthor:(NSString *)author 
             content:(NSString *)content 
         serviceType:(NSString *)serviceType 
      authorRealName:(NSString *)authorRealName
           timestamp:(NSDate *)timestamp;

- (NSString *)description;
// TODO: isEqual + hashCode

@end
