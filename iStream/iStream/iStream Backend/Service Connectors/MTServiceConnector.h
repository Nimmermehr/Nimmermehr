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

@property (nonatomic, readonly) BOOL authenticated;
@property (nonatomic) BOOL autoPolling;
@property (nonatomic) NSTimeInterval autoPollingInterval;
@property (weak, nonatomic) id<MTServiceConnectorDelegate> delegate;

@end
