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
- (void)authenticate;
- (BOOL)authenticated;
- (NSString *)serviceType;
@property (nonatomic) BOOL autoPolling;
@property (nonatomic) float autoPollingInterval;
@property (weak, nonatomic) id<MTServiceConnectorDelegate> delegate;

@end
