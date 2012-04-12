//
//  MTServiceConnectorManager.m
//  TwitterConnect
//
//  Created by Thomas Kober on 3/31/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTServiceConnectorManager.h"
#import "MTServiceConnector.h"
#import "MTTwitterConnector.h"
#import "MTNewsItem.h"

@interface MTServiceConnectorManager (Private)
- (void)initSharedInstance;
@end

@implementation MTServiceConnectorManager

@synthesize autoPolling         = _autoPolling;
@synthesize autoPollingInterval = _autoPollingInterval;

static MTServiceConnectorManager *_sharedInstance = nil;

+ (MTServiceConnectorManager *)sharedServiceConnectorManager
{
    if (_sharedInstance == nil) {
        _sharedInstance = [[super allocWithZone:NULL] init];
        
        [_sharedInstance initSharedInstance];
    }
    
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedServiceConnectorManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)connectService:(id<MTServiceConnector>)service
{
    [_services setObject:service forKey:[service serviceType]];
    
    [service setDelegate:self];
}

- (void)createAndConnectService:(NSString *)serviceType
{
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        id<MTServiceConnector> twitter = [[MTTwitterConnector alloc] init];
        
        [self connectService:twitter];
    } 
}

- (void)authenticateService:(NSString *)serviceType
{
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        [[_services objectForKey:MTServiceTypeTwitter] authenticate];
    }
}

- (void)authenticateServices
{
    for (id<MTServiceConnector> service in [_services allValues]) {
        [service authenticate];
    }
}

- (id<MTServiceConnector>)serviceForType:(NSString *)serviceType
{
    return [_services objectForKey:serviceType];
}

- (void)disconnectService:(NSString *)serviceType
{
    [_services removeObjectForKey:serviceType];
}

- (BOOL)isServiceAuthenticated:(NSString *)serviceType
{
    return [[_services objectForKey:serviceType] authenticated];
}

- (BOOL)isServiceConnected:(NSString *)serviceType
{
    return [_services objectForKey:serviceType] != nil;
}

- (void)requestContentForAllConnectedServices
{
    [self requestTwitterUserTimeline];
    [self requestTwitterReplyMessages];
    [self requestTwitterDirectMessages];
}

- (void)requestContentForService:(NSString *)serviceType
{
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        [self requestTwitterUserTimeline];
        [self requestTwitterReplyMessages];
        [self requestTwitterDirectMessages];
    }
}

#pragma mark Twitter specific Service Implementation

- (void)requestTwitterUserTimeline
{
    MTTwitterConnector *twitterConnector = [_services objectForKey:MTServiceTypeTwitter];
    
    if (twitterConnector) {
        [twitterConnector requestUserTimeline];
    }
}

- (void)requestTwitterPublicTimeline
{
    MTTwitterConnector *twitterConnector = [_services objectForKey:MTServiceTypeTwitter];
    
    if (twitterConnector) {
        [twitterConnector requestPublicTimeline];
    }
}

- (void)requestTwitterReplyMessages
{
    MTTwitterConnector *twitterConnector = [_services objectForKey:MTServiceTypeTwitter];
    
    if (twitterConnector) {
        [twitterConnector requestReplyMessages];
    }
}

- (void)requestTwitterDirectMessages
{
    MTTwitterConnector *twitterConnector = [_services objectForKey:MTServiceTypeTwitter];
    
    if (twitterConnector) {
        [twitterConnector requestDirectMessages];
    }
}

#pragma mark MTServiceConnectorDelegate Implementation
- (void)serviceAuthenticatedSuccessfully:(NSString *)serviceType
{
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTTwitterAuthenticationSucceeded object:self];
        
        _authenticatedServices++;
    }
    
    // TODO: We need some checking authenticatedServices vs. failedServices, etc
    
    if (_authenticatedServices == [_services count]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTAllServicesAuthenticationSucceeded object:self];
        
    }
}

- (void)serviceAuthenticationFailed:(NSString *)serviceType errDict:(NSDictionary *)errDict
{
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTTwitterAuthenticationFailed object:self userInfo:errDict];
        
    }
}

- (void)accessNotGranted:(NSString *)serviceType
{
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTTwitterAccessNotGranted object:self];
        
    }
}

- (void)contentReceived:(NSDictionary *)theContent
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MTServiceNewsItemsReceived object:self userInfo:theContent];
    
    if ([[theContent objectForKey:MTServiceTypeKey] isEqualToString:MTServiceTypeTwitter]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTTwitterNewsItemsReceived object:self userInfo:theContent];
        
    }
}

@end

@implementation MTServiceConnectorManager (Private)

- (void)initSharedInstance
{
    _services = [[NSMutableDictionary alloc] init];
    _authenticatedServices = 0;
    
    // Check DB/Prefs File for connected services and add them
}

@end
