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
#import "MTFoursquareConnector.h"
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

- (void)setAutoPolling:(BOOL)autoPolling
{
    if (autoPolling) {
        _scheduler = [NSTimer scheduledTimerWithTimeInterval:_autoPollingInterval target:self selector:@selector(pollForContent:) userInfo:nil repeats:YES];
    } else {
        [_scheduler invalidate];
        _scheduler = nil;
    }
    
    _autoPolling = autoPolling;
}

- (void)setAutoPollingInterval:(NSTimeInterval)autoPollingInterval
{
    _autoPollingInterval = autoPollingInterval;
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
        
    } else if ([serviceType isEqualToString:MTServiceTypeFoursquare]) {
        
        id<MTServiceConnector> foursquare = [[MTFoursquareConnector alloc] init];
        
        [self connectService:foursquare];
        
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
    } else if ([serviceType isEqualToString:MTServiceTypeFoursquare]) {
        [[_services objectForKey:MTServiceTypeFoursquare] authenticate];
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

- (NSArray *)getAuthenticatedServices
{
    NSMutableArray *authenticatedServices = [NSMutableArray array];
    
    for (id<MTServiceConnector> service in [_services allValues]) {
        if ([service authenticated]) {
            [authenticatedServices addObject:service];
        }
    }
    
    return (NSArray *)authenticatedServices;
}

- (NSArray *)getAvailableServiceContentTypesForService:(NSString *)serviceType
{
    NSArray *availableContentTypes = nil;
    
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        
        availableContentTypes = [NSArray arrayWithObjects:
                                 MTServiceContentTypeUserTimeline,
                                 MTServiceContentTypeUserWall,    
                                 MTServiceContentTypeUserPosts,
                                 MTServiceContentTypeUserMessages,
                                 nil
                                 ];
        
    } else if ([serviceType isEqualToString:MTServiceTypeFacebook]) {
        
        availableContentTypes = [NSArray arrayWithObjects:
                                 MTServiceContentTypeUserTimeline,
                                 MTServiceContentTypeUserWall,
                                 MTServiceContentTypeUserPosts,   
                                 MTServiceContentTypeUserMessages,
                                 nil
                                 ];
        
    }
    
    return availableContentTypes;
}

// TODO: rebuild interface to make use of MTServiceContentType
- (void)requestContentForAllConnectedServices
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeTwitter]) {
        [self requestTwitterUserTimeline];
        [self requestTwitterReplyMessages];
        [self requestTwitterDirectMessages];
        [self requestTwitterUserPosts];
    } else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:MTServiceTypeTwitter!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
    
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeFacebook]) {
        [self requestFacebookUserTimeline];
        [self requestFacebookUserWall];
        [self requestFacebookUserPosts];
    } else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:MTServiceTypeFacebook!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
    
    
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeGooglePlus]) {
        [self requestGooglePlusUserTimeline];
        [self requestGooglePlusUserWall];
        [self requestGooglePlusUserPosts];
    } else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:MTServiceTypeGooglePlus!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
    
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeFoursquare]) {
        
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
    } else if ([serviceType isEqualToString:MTServiceTypeFoursquare]) {
        
    }
}

- (UIImage *)iconForServiceType:(NSString *)serviceType
{
    UIImage *serviceIcon = nil;
    
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        serviceIcon = [MTTwitterConnector serviceIcon];
    } else if ([serviceType isEqualToString:MTServiceTypeFacebook]) {
        serviceIcon = [MTFacebookConnector serviceIcon];
    } else if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        serviceIcon = [MTGooglePlusConnector serviceIcon];
    } else if ([serviceType isEqualToString:MTServiceTypeFoursquare]) {
        serviceIcon = [MTFoursquareConnector serviceIcon];
    }
    
    return serviceIcon;
}

- (void)pollForContent:(NSTimer *)theTimer
{ // Experimental...atm at your own risk (not really tested)
    [self requestContentForAllConnectedServices]; 
}

#pragma mark Facebook specific Service Implementation
- (void)requestFacebookUserTimeline
{
    // TODO: Maybe use Exceptions instead of Notifs??
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeFacebook]) {
        [[_services objectForKey:MTServiceTypeFacebook] requestUserTimeline];
    } else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
}

- (void)requestFacebookUserWall
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeFacebook]) {
        [[_services objectForKey:MTServiceTypeFacebook] requestUserWall];
    } else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	} 
}

- (void)requestFacebookUserPosts
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeFacebook]) {
        [[_services objectForKey:MTServiceTypeFacebook] requestUserPosts];
    } else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
}

- (void)logoutFromFacebook
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeFacebook]) {
        [[_services objectForKey:MTServiceTypeFacebook] logout];
    } else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
}

#pragma mark Twitter specific Service Implementation

- (void)requestTwitterUserTimeline
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeTwitter]) {
        [[_services objectForKey:MTServiceTypeTwitter] requestUserTimeline];
    } else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
}

- (void)requestTwitterPublicTimeline
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeTwitter]) {
        [[_services objectForKey:MTServiceTypeTwitter] requestPublicTimeline];
    } else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
}

- (void)requestTwitterReplyMessages
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeTwitter]) {
        [[_services objectForKey:MTServiceTypeTwitter] requestReplyMessages];
    } else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
}

- (void)requestTwitterDirectMessages
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeTwitter]) {
        [[_services objectForKey:MTServiceTypeTwitter] requestDirectMessages];
    } else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
}

- (void)requestTwitterUserPosts
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeTwitter]) {
        [[_services objectForKey:MTServiceTypeTwitter] requestUserPosts];
    }  else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
}

- (void)logoutFromTwitter
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeTwitter]) {
        [[_services objectForKey:MTServiceTypeTwitter] logout];
    }  else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
}

#pragma mark Google+ specific Implementation
- (void)requestGooglePlusUserTimeline
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeGooglePlus]) {
        [[_services objectForKey:MTServiceTypeGooglePlus] requestUserTimeline];
    }  else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
}

- (void)requestGooglePlusUserWall
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeGooglePlus]) {
        [[_services objectForKey:MTServiceTypeGooglePlus] requestUserWall];
    } else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
}

- (void)requestGooglePlusUserPosts
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeGooglePlus]) {
        [[_services objectForKey:MTServiceTypeGooglePlus] requestUserPosts];
    } else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
}

- (void)logoutFromGooglePlus
{
    if ([self checkServiceConnectedAndAuthenticated:MTServiceTypeGooglePlus]) {
        [[_services objectForKey:MTServiceTypeGooglePlus] logout];
    } else {
		DLog(@"%@.%@ - failed -checkServiceConnectedAndAuthenticated:!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	}
}

#pragma mark Foursquare specific Service Implementation
- (void)requestFoursquareCheckIns
{
    [[_services objectForKey:MTServiceTypeFoursquare] requestCheckIns];
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
        
    } else if ([serviceType isEqualToString:MTServiceTypeFoursquare]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFoursquareAuthenticationSucceeded object:self];
        
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
        
    } else if ([serviceType isEqualToString:MTServiceTypeFoursquare]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFoursquareAuthenticationFailed object:self userInfo:errDict];
        
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
        
    } else if ([serviceType isEqualToString:MTServiceTypeFoursquare]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFoursquareAccessNotGranted object:self];
        
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
        
    } else if ([serviceType isEqualToString:MTServiceTypeFoursquare]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFoursquareConnectionInterrupted object:self userInfo:errDict];
        
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
        
    } else if ([serviceType isEqualToString:MTServiceTypeFoursquare]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFoursquareConnectionReEstablished object:self];
        
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
        
    } else if ([[theContent objectForKey:MTServiceTypeKey] isEqualToString:MTServiceTypeFoursquare]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFoursquareNewsItemsReceived object:self userInfo:theContent];
        
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
        
    } else if ([[errDict objectForKey:MTServiceTypeKey] isEqualToString:MTServiceTypeFoursquare]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFoursquareNewsItemsRequestFailed object:self userInfo:errDict];
        
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
        
    } else if ([serviceType isEqualToString:MTServiceTypeFoursquare]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFoursquareLogoutCompleted object:self];
        
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
    DLog(@"SELF MANAGER: %@", self);
    
    if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusOAuth2DialogNeedsDisplay object:self userInfo:[NSDictionary dictionaryWithObject:theDialog forKey:MTServiceOAuth2UserDialog]];
        
    } else if ([serviceType isEqualToString:MTServiceTypeFoursquare]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFoursquareOAuth2DialogNeedsDisplay object:self userInfo:[NSDictionary dictionaryWithObject:theDialog forKey:MTServiceOAuth2UserDialog]];
    }
}

- (void)dismissOAuth2UserDialog:(NSString *)serviceType
{
    if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusOAuth2DialogNeedsDismissal object:self];
        
    } else if ([serviceType isEqualToString:MTServiceTypeFoursquare]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFoursquareOAuth2DialogNeedsDismissal object:self];
    }
}

- (void)serviceDidStartLoading:(NSString *)serviceType
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MTServiceDidStartLoading object:self userInfo:[NSDictionary dictionaryWithObject:serviceType forKey:MTServiceTypeKey]];
    
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTTwitterDidStartLoading object:self];
        
    } else if ([serviceType isEqualToString:MTServiceTypeFacebook]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFacebookDidStartLoading object:self];
        
    } else if ([serviceType isEqualToString:MTServiceTypeGooglePlus]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTGooglePlusDidStartLoading object:self];
        
    } else if ([serviceType isEqualToString:MTServiceTypeFoursquare]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MTFoursquareDidStartLoading object:self];
    }
}

@end

@implementation MTServiceConnectorManager (Private)

- (void)initSharedInstance
{
    _services = [[NSMutableDictionary alloc] init];
    _authenticatedServices = 0;
    
    _autoPollingInterval = 30;
    
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
        
    } else if ([serviceType isEqualToString:MTServiceTypeFoursquare]) {
        
        if ([_services objectForKey:MTServiceTypeFoursquare]) {
            if ([[_services objectForKey:MTServiceTypeFoursquare] authenticated]) {
                connectedAndAuthenticated = YES;
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:MTFoursquareNotAuthenticated object:self];
            }
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:MTFoursquareServiceNotConnected object:self];
        }
        
    }
    
    return connectedAndAuthenticated;
}

@end