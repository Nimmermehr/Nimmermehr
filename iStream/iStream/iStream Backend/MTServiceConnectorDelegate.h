//
//  MTServiceConnectorDelegate.h
//  iStream
//
//  Created by Thomas Kober on 4/1/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTMOAuth2ViewControllerTouch;
@protocol MTServiceConnectorDelegate <NSObject>

@required
- (void)serviceAuthenticatedSuccessfully:(NSString *)serviceType;
- (void)serviceAuthenticationFailed:(NSString *)serviceType errDict:(NSDictionary *)errDict;

- (void)serviceLogoutCompleted:(NSString *)serviceType;

- (void)serviceConnectionInterrupted:(NSString *)serviceType errDict:(NSDictionary *)errDict;
- (void)serviceConnectionReEstablished:(NSString *)serviceType;

- (void)serviceDidStartLoading:(NSString *)serviceType;

- (void)accessNotGranted:(NSString *)serviceType;

- (void)contentReceived:(NSDictionary *)theContent;
- (void)contentRequestFailed:(NSDictionary *)errDict;

- (void)displayOAuth2UserDialog:(NSString *)serviceType userDialog:(id)theDialog;
- (void)dismissOAuth2UserDialog:(NSString *)serviceType;

// Facebook specific SSO Callback
- (BOOL)handleFacebookSSOCallback:(NSURL *)theURL;

@end
