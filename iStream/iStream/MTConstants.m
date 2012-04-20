//
//  MTConstants.m
//  iStream
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
NSString * const MTFacebookAppSecret    = @"ecc46b32cb22e0d0db046c7d4b215fe9";
NSString * const MTGooglePlusAppId      = @"1045145999063.apps.googleusercontent.com";
NSString * const MTGooglePlusAppSecret  = @"OjrMiXR2pjojH4DPK_mwbsdB";

NSString * const MTTwitterDidStartLoading               = @"TwitterDidStartLoading";
NSString * const MTTwitterAuthenticationSucceeded       = @"TwitterAuthenticationSucceeded";
NSString * const MTTwitterNotAuthenticated              = @"TwitterNotAuthenticated";
NSString * const MTTwitterServiceNotConnected           = @"TwittterServiceNotConnected";
NSString * const MTTwitterAuthenticationFailed          = @"TwitterAuthenticationFailed";
NSString * const MTTwitterConnectionInterrupted         = @"TwitterConnectionInterrupted";
NSString * const MTTwitterConnectionReEstablished       = @"TwitterConnectionReEstablished";
NSString * const MTTwitterAccessNotGranted              = @"TwitterAccessNotGranted";
NSString * const MTTwitterNewsItemsReceived             = @"TwitterNewsItemsReceived";
NSString * const MTTwitterNewsItemsRequestFailed        = @"TwitterNewsItemsRequestFailed";
NSString * const MTTwitterLogoutCompleted               = @"TwitterLogoutCompleted";

NSString * const MTFacebookDidStartLoading              = @"FacebookDidStartLoading";
NSString * const MTFacebookAuthenticationSucceeded      = @"FacebookAuthenticationSucceeded";
NSString * const MTFacebookNotAuthenticated             = @"FacebookNotAuthenticated";
NSString * const MTFacebookServiceNotConnected          = @"FacebookServiceNotConnected";
NSString * const MTFacebookAuthenticationFailed         = @"FacebookAuthenticationFailed";
NSString * const MTFacebookConnectionInterrupted        = @"FacebookConnectionInterrupted";
NSString * const MTFacebookConnectionReEstablished      = @"FacebookConnectionReEstablished";
NSString * const MTFacebookAccessNotGranted             = @"FacebookAccessNotGranted";
NSString * const MTFacebookNewsItemsReceived            = @"FacebookNewsItemsReceived";
NSString * const MTFacebookNewsItemsRequestFailed       = @"FacebookNewsItemsRequestFailed";
NSString * const MTFacebookLogoutCompleted              = @"FacebookLogoutCompleted";

NSString * const MTGooglePlusDidStartLoading            = @"GooglePlusDidStartLoading";
NSString * const MTGooglePlusAuthenticationSucceeded    = @"GooglePlusAuthenticationSucceeded";
NSString * const MTGooglePlusNotAuthenticated           = @"GooglePlusNotAuthenticated";
NSString * const MTGooglePlusServiceNotConnected        = @"GooglePlusServiceNotConnected";
NSString * const MTGooglePlusAuthenticationFailed       = @"GooglePlusAuthenticationFailed";
NSString * const MTGooglePlusConnectionInterrupted      = @"GooglePlusConnectionInterrupted";
NSString * const MTGooglePlusConnectionReEstablished    = @"GooglePlusConnectionReEstablished";
NSString * const MTGooglePlusAccessNotGranted           = @"GooglePlusAccessNotGranted";
NSString * const MTGooglePlusNewsItemsReceived          = @"GooglePlusNewsItemsReceived";
NSString * const MTGooglePlusNewsItemsRequestFailed     = @"GooglePlusNewsItemsRequestFailed";
NSString * const MTGooglePlusLogoutCompleted            = @"GooglePlusLogoutCompleted";
NSString * const MTGooglePlusOAuthScope                 = @"https://www.googleapis.com/auth/plus.me";
NSInteger  const MTGooglePlusAccessNotGrantedErrorCode  = -1001;
NSString * const MTGooglePlusOAuth2DialogNeedsDisplay   = @"GooglePlusOAuth2DialogNeedsDisplay";
NSString * const MTGooglePlusOAuth2DialogNeedsDismissal = @"GooglePlusOAuth2DialogNeedsDismissal";

NSString * const MTAllServicesAuthenticationSucceeded   = @"AllServicesAuthenticationSucceeded";
NSString * const MTServiceNewsItemsReceived             = @"ServiceNewsItemsReceived";
NSString * const MTServiceNewsItemsRequestFailed        = @"ServiceNewsItemsRequestFailed";
NSString * const MTServiceDidStartLoading               = @"ServiceDidStartLoading";

NSString * const MTServiceAuthenticationErrorKey            = @"authError";
NSString * const MTServiceTypeKey                           = @"serviceType";
NSString * const MTServiceContentKey                        = @"serviceContent";
NSString * const MTServiceContentRequestFailedErrorKey      = @"reqError";
NSString * const MTServiceContentRequestFailedResponseKey   = @"urlResponse";
NSString * const MTServiceOAuth2UserDialog                  = @"oAuth2UserDialog";