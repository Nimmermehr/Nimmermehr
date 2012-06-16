//
//  MTFoursquareConnector.h
//  iStream
//
//  Created by Thomas Kober on 4/25/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTServiceConnector.h"


@protocol MTServiceConnectorDelegate;
@class GTMOAuth2ViewControllerTouch;
@class GTMOAuth2Authentication;

@interface MTFoursquareConnector : NSObject<MTServiceConnector> {
@private    
    BOOL                                _authenticated;
    GTMOAuth2ViewControllerTouch        *_viewController;
    __strong GTMOAuth2Authentication    *_authToken;
}

@property (nonatomic, readonly) BOOL                            authenticated;
@property (weak, nonatomic)     id<MTServiceConnectorDelegate>  delegate;

- (void)authenticate;
- (NSString *)serviceType;
- (void)logout;

- (void)requestCheckIns;

@end
