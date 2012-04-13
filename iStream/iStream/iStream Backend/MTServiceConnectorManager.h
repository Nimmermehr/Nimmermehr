//
//  MTServiceConnectorManager.h
//  TwitterConnect
//
//  Created by Thomas Kober on 3/31/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTServiceConnectorDelegate.h"

@protocol MTServiceConnector;
@protocol MTServiceConnectorManagerDelegate;

@interface MTServiceConnectorManager : NSObject <MTServiceConnectorDelegate> {
@private
    NSMutableDictionary *_services;
    
    NSUInteger _authenticatedServices;
    
    BOOL _autoPolling;
    float _autoPollingInterval;
}

@property (nonatomic) BOOL  autoPolling;
@property (nonatomic) float autoPollingInterval;

// Singleton to manage all services
// All services comply to the MTServiceConnectorProtocol
// Callbacks if finished connecting evtl via delegate
// Also handle the database here, if the frontend requests the @msgs eg, first check the db, then load from web

+ (MTServiceConnectorManager *)sharedServiceConnectorManager;

+ (id)allocWithZone:(NSZone *)zone;

- (id)copyWithZone:(NSZone *)zone;

- (void)connectService:(id<MTServiceConnector>)service;

- (void)createAndConnectService:(NSString *)serviceType;

- (void)authenticateServices;

- (void)authenticateService:(NSString *)serviceType;

- (id<MTServiceConnector>)serviceForType:(NSString *)serviceType;

- (void)disconnectService:(NSString *)serviceType;

- (BOOL)isServiceAuthenticated:(NSString *)serviceType;

- (BOOL)isServiceConnected:(NSString *)serviceType;

// All Services
- (void)requestContentForAllConnectedServices;

- (void)requestContentForService:(NSString *)serviceType;

// Twitter specific methods
- (void)requestTwitterUserTimeline;
- (void)requestTwitterPublicTimeline;
- (void)requestTwitterReplyMessages;
- (void)requestTwitterDirectMessages;

// Facebook specific methods
- (void)requestFacebookUserTimeline;
- (void)requestFacebookUserWall;
- (void)requestFacebookUserPosts;

@end
