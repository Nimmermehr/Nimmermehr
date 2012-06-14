//
//  MTServiceConnector.h
//  TwitterConnect
//
//  Created by Thomas Kober on 3/31/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTServiceConnectorDelegate;

@protocol MTServiceConnector <NSObject>

@required
+ (UIImage *)serviceIcon;
- (void)authenticate;
- (NSString *)serviceType;
- (void)logout;

// Add methods for account management: get, add, delete (probably with MTUser as argument)
// Add methods for content management: request (with options based on MTServiceContentType as argument)
// Maybe re-implement auto polling on service level --> TODO: to be discussed

@property (nonatomic, readonly) BOOL authenticated;
@property (weak, nonatomic) id<MTServiceConnectorDelegate> delegate;

@end
