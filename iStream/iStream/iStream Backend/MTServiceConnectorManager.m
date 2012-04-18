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
#import "MTFacebookConnector.h"
#import "MTGooglePlusConnector.h"
#import "MTNewsItem.h"

@interface MTServiceConnectorManager (Private)
- (void)initSharedInstance;
- (BOOL)checkServiceConnectedAndAuthenticated:(NSString *)serviceType;
@end

@implementation MTServiceConnectorManager

@synthesize autoPolling         = _autoPolling;
@synthesize autoPollingInterval = _autoPollingInterval;

__strong static MTServiceConnectorManager *_sharedInstance = nil;

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
    
    } else if ([serviceType isEqualToString:MTServiceTypeFacebook]) {
        
        id<MTServiceConnector> facebook = [[MTFacebookConnector alloc] init];
        
        [self connectService:facebook];
    
    } else if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        
        id<MTServiceConnector> googlePlus = [[MTGooglePlusConnector alloc] init];
        
            
        [self connectService:googlePlus];
    }
}

- (void)authenticateService:(NSString *)serviceType
{
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        [[_services objectForKey:MTServiceTypeTwitter] authenticate];
    } else if ([serviceType isEqualToString:MTServiceTypeFacebook]) {
        [[_services objectForKey:MTServiceTypeFacebook] authenticate];
    } else if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        [[_services objectForKey:MTServiceTypeGooglePlus] authenticate];
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
    if ([self isServiceConnected:MTServiceTypeTwitter]) {
        [self requestTwitterUserTimeline];
        [self requestTwitterReplyMessages];
        [self requestTwitterDirectMessages];
        [self requestTwitterUserPosts];
    }
    
    if ([self isServiceConnected:MTServiceTypeFacebook]) {
        [self requestFacebookUserTimeline];
        [self requestFacebookUserWall];
        [self requestFacebookUserPosts];
    }
    
    if ([self isServiceConnected:MTServiceTypeGooglePlus]) {
        [self requestGooglePlusUserTimeline];
        [self requestGooglePlusUserWall];
        [self requestGooglePlusUserPosts];
    }
}

- (void)requestContentForService:(NSString *)serviceType
{
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        [self requestTwitterUserTimeline];
        [self requestTwitterReplyMessages];
        [self requestTwitterDirectMessages];
        [self requestTwitterUserPosts];
    } else if ([serviceType isEqualToString:MTServiceTypeFacebook]) {
        [self requestFacebookUserTimeline];
        [self requestFacebookUserWall];
        [self requestFacebookUserPosts];
    } else if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        [self requestGooglePlusUserTimeline];
        [self requestGooglePlusUserWall];
        [self requestGooglePlusUserPosts];
    }
}

#pragma mark Facebook specific Service Implementation
- (void)requestFacebookUserTimeline
{
    // TODO: Maybe use Exceptions instead of Notifs??
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeFacebook]) {
        [[_services objectForKey:MTServiceTypeFacebook] requestUserTimeline];
    } 
}

- (void)requestFacebookUserWall
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeFacebook]) {
        [[_services objectForKey:MTServiceTypeFacebook] requestUserWall];
    } 
}

- (void)requestFacebookUserPosts
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeFacebook]) {
        [[_services objectForKey:MTServiceTypeFacebook] requestUserPosts];
    }
}

- (void)logoutFromFacebook
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeFacebook]) {
        [[_services objectForKey:MTServiceTypeFacebook] logout];
    }
}

#pragma mark Twitter specific Service Implementation

- (void)requestTwitterUserTimeline
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeTwitter]) {
        [[_services objectForKey:MTServiceTypeTwitter] requestUserTimeline];
    }
}

- (void)requestTwitterPublicTimeline
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeTwitter]) {
        [[_services objectForKey:MTServiceTypeTwitter] requestPublicTimeline];
    }
}

- (void)requestTwitterReplyMessages
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeTwitter]) {
        [[_services objectForKey:MTServiceTypeTwitter] requestReplyMessages];
    }
}

- (void)requestTwitterDirectMessages
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeTwitter]) {
        [[_services objectForKey:MTServiceTypeTwitter] requestDirectMessages];
    }
}

- (void)requestTwitterUserPosts
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeTwitter]) {
        [[_services objectForKey:MTServiceTypeTwitter] requestUserPosts];
    }
}

- (void)logoutFromTwitter
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeTwitter]) {
        [[_services objectForKey:MTServiceTypeTwitter] logout];
    }
}

#pragma mark Google+ specific Implementation
- (void)requestGooglePlusUserTimeline
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeGooglePlus]) {
        [[_services objectForKey:MTServiceTypeGooglePlus] requestUserTimeline];
    }
}

- (void)requestGooglePlusUserWall
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeGooglePlus]) {
        [[_services objectForKey:MTServiceTypeGooglePlus] requestUserWall];
    }
}

- (void)requestGooglePlusUserPosts
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeGooglePlus]) {
        [[_services objectForKey:MTServiceTypeGooglePlus] requestUserPosts];
    }
}

- (void)logoutFromGooglePlus
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeGooglePlus]) {
        [[_services objectForKey:MTServiceTypeGooglePlus] logout];
    }
}

#pragma mark MTServiceConnectorDelegate Implementation
- (void)serviceAuthenticatedSuccessfully:(NSString *)serviceType
{
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTTwitterAuthenticationSucceeded object:self];
        
        _authenticatedServices++;
    
    } else if ([serviceType isEqualToString:MTServiceTypeFacebook]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFacebookAuthenticationSucceeded object:self];
        
        _authenticatedServices++;
            
    } else if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusAuthenticationSucceeded object:self];
        
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
        
    } else if ([serviceType isEqualToString:MTServiceTypeFacebook]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFacebookAuthenticationFailed object:self userInfo:errDict];
        
    } else if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusAuthenticationFailed object:self userInfo:errDict];
        
    }
}

- (void)accessNotGranted:(NSString *)serviceType
{
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTTwitterAccessNotGranted object:self];
        
    } else if ([serviceType isEqualToString:MTServiceTypeFacebook]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFacebookAccessNotGranted object:self];
        
    } else if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusAccessNotGranted object:self];
        
    }
}

- (void)serviceConnectionInterrupted:(NSString *)serviceType errDict:(NSDictionary *)errDict
{
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTTwitterConnectionInterrupted object:self userInfo:errDict];
        
    } else if ([serviceType isEqualToString:MTServiceTypeFacebook]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFacebookConnectionInterrupted object:self userInfo:errDict];
        
    } else if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusConnectionInterrupted object:self userInfo:errDict];
        
    }
}

- (void)serviceConnectionReEstablished:(NSString *)serviceType
{
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTTwitterConnectionReEstablished object:self];
        
    } else if ([serviceType isEqualToString:MTServiceTypeFacebook]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFacebookConnectionReEstablished object:self];
        
    } else if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusConnectionReEstablished object:self];
        
    }
}

- (void)contentReceived:(NSDictionary *)theContent
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MTServiceNewsItemsReceived object:self userInfo:theContent];
    
    if ([[theContent objectForKey:MTServiceTypeKey] isEqualToString:MTServiceTypeTwitter]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTTwitterNewsItemsReceived object:self userInfo:theContent];
        
    } else if ([[theContent objectForKey:MTServiceTypeKey] isEqualToString:MTServiceTypeFacebook]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFacebookNewsItemsReceived object:self userInfo:theContent];
        
    } else if ([[theContent objectForKey:MTServiceTypeKey] isEqualToString:MTServiceTypeGooglePlus]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusNewsItemsReceived object:self userInfo:theContent];
    }
}

- (void)contentRequestFailed:(NSDictionary *)errDict
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MTServiceNewsItemsRequestFailed object:self userInfo:errDict];
    
    if ([[errDict objectForKey:MTServiceTypeKey] isEqualToString:MTServiceTypeKey]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTTwitterNewsItemsRequestFailed object:self userInfo:errDict];
        
    } else if ([[errDict objectForKey:MTServiceTypeKey] isEqualToString:MTServiceTypeFacebook]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFacebookNewsItemsRequestFailed object:self userInfo:errDict];
        
    } else if ([[errDict objectForKey:MTServiceTypeKey] isEqualToString:MTServiceTypeGooglePlus]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusNewsItemsRequestFailed object:self userInfo:errDict];
        
    }
}

- (void)serviceLogoutCompleted:(NSString *)serviceType
{
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTTwitterLogoutCompleted object:self];
        
    } else if ([serviceType isEqualToString:MTServiceTypeFacebook]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFacebookLogoutCompleted object:self];
        
    } else if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusLogoutCompleted object:self];
        
    }
}

- (BOOL)handleFacebookSSOCallback:(NSURL *)theURL
{
    MTFacebookConnector *facebookConnector = [_services objectForKey:MTServiceTypeFacebook];
    
    BOOL canHandle = NO;
    
    if (facebookConnector && [facebookConnector respondsToSelector:@selector(handleSSOCallback:)]) {
        canHandle = [facebookConnector handleSSOCallback:theURL];
    }
    
    return canHandle;
}

- (void)displayOAuth2UserDialog:(NSString *)serviceType userDialog:(id)theDialog
{
    NSLog(@"SELF MANAGER: %@", self);
    
    if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusOAuth2DialogNeedsDisplay object:self userInfo:[NSDictionary dictionaryWithObject:theDialog forKey:MTServiceOAuth2UserDialog]];
    
    }
}

- (void)dismissOAuth2UserDialog:(NSString *)serviceType
{
    if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusOAuth2DialogNeedsDismissal object:self];
        
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

- (BOOL)checkServiceConnectedAndAuthenticated:(NSString *)serviceType
{
    BOOL connectedAndAuthenticated = NO;
    
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        
        if ([_services objectForKey:MTServiceTypeTwitter]) {
            if ([[_services objectForKey:MTServiceTypeTwitter] authenticated]) {
                connectedAndAuthenticated = YES;
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:MTTwitterNotAuthenticated object:self];
            }
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:MTTwitterServiceNotConnected object:self];
        }
        
    } else if ([serviceType isEqualToString:MTServiceTypeFacebook]) {
        
        if ([_services objectForKey:MTServiceTypeFacebook]) {
            if ([[_services objectForKey:MTServiceTypeFacebook] authenticated]) {
                connectedAndAuthenticated = YES;
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:MTFacebookNotAuthenticated object:self];
            }
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:MTFacebookServiceNotConnected object:self];
        }
        
    } else if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        
        if ([_services objectForKey:MTServiceTypeGooglePlus]) {
            if ([[_services objectForKey:MTServiceTypeGooglePlus] authenticated]) {
                connectedAndAuthenticated = YES;
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusNotAuthenticated object:self];
            }
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusServiceNotConnected object:self];
        }
    }
    
    return connectedAndAuthenticated;
}

@end
