//
//  MTServiceConnectorDelegate.h
//  TwitterConnect
//
//  Created by Thomas Kober on 4/1/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTServiceConnectorDelegate <NSObject>

- (void)serviceAuthenticatedSuccessfully:(NSString *)serviceType;
- (void)serviceAuthenticationFailed:(NSString *)serviceType errDict:(NSDictionary *)errDict;

- (void)accessNotGranted:(NSString *)serviceType;

- (void)contentReceived:(NSDictionary *)theContent;

@end
