//
//  MTConstants.m
//  TwitterConnect
//
//  Created by Thomas Kober on 3/31/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTConstants.h"

NSString * const MTServiceTypeTwitter       = @"Twitter";
NSString * const MTServiceTypeFacebook      = @"Facebook";
NSString * const MTServiceTypeTumblr        = @"Tumblr";
NSString * const MTServiceTypeGooglePlus    = @"Google+";
NSString * const MTServiceTypeBitly         = @"Bit.ly";

NSString * const MTTwitterAppId         = @"wk79XRDGhXbiaN3o3XI2Cw";
NSString * const MTTwitterAppSecret     = @"jPJxaTAVUJdV768fUSUmCX6JHoVpTQ8WPPlwTqRWnz0";
NSString * const MTFacebookAppId        = @"351817994870666";
NSString * const MTFacebookAppSecret    = @"fe8fe1013f147a3a11c6fea35449f7dd";

NSString * const MTTwitterAuthenticationSucceeded       = @"TwitterAuthenticationSucceeded";
NSString * const MTTwitterAuthenticationFailed          = @"TwitterAuthenticationFailed";
NSString * const MTTwitterConnectionInterrupted         = @"TwitterConnectionInterrupted";
NSString * const MTTwitterConnectionReEstablished       = @"TwitterConnectionReEstablished";
NSString * const MTTwitterAccessNotGranted              = @"TwitterAccessNotGranted";
NSString * const MTTwitterNewsItemsReceived             = @"TwitterNewsItemsReceived";

NSString * const MTFacebookAuthenticationSucceeded      = @"FacebookAuthenticationSucceeded";
NSString * const MTFacebookAuthenticationFailed         = @"FacebookAuthenticationFailed";
NSString * const MTFacebookConnectionInterrupted        = @"FacebookConnectionInterrupted";
NSString * const MTFacebookConnectionReEstablished      = @"FacebookConnectionReEstablished";
NSString * const MTFacebookAccessNotGranted             = @"FacebookAccessNotGranted";
NSString * const MTFacebookNewsItemsReceived            = @"FacebookNewsItemsReceived";

NSString * const MTAllServicesAuthenticationSucceeded   = @"AllServicesAuthenticationSucceeded";
NSString * const MTServiceNewsItemsReceived             = @"ServiceNewsItemsReceived";
NSString * const MTServiceAuthenticationErrorKey        = @"authError";
NSString * const MTServiceTypeKey                       = @"serviceType";
NSString * const MTServiceContentKey                    = @"serviceContent";