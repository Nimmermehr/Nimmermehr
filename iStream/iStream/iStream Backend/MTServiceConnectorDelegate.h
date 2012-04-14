//
//  MTServiceConnectorDelegate.h
//  TwitterConnect
//
//  Created by Thomas Kober on 4/1/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTServiceConnectorDelegate <NSObject>

@required
- (void)serviceAuthenticatedSuccessfully:(NSString *)serviceType;
- (void)serviceAuthenticationFailed:(NSString *)serviceType errDict:(NSDictionary *)errDict;

- (void)serviceLogoutCompleted:(NSString *)serviceType;

- (void)serviceConnectionInterrupted:(NSString *)serviceType errDict:(NSDictionary *)errDict;
- (void)serviceConnectionReEstablished:(NSString *)serviceType;

- (void)accessNotGranted:(NSString *)serviceType;

- (void)contentReceived:(NSDictionary *)theContent;
- (void)contentRequestFailed:(NSDictionary *)errDict;

@end
