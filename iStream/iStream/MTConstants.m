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
NSString * const MTServiceTypeFoursquare    = @"Foursquare";
NSString * const MTServiceTypeFlickr        = @"Flickr";
NSString * const MTServiceTypeLinkedIn      = @"LinkedIn";
NSString * const MTServiceTypeBitly         = @"Bit.ly";

NSString * const MTServiceContentTypeNone           = @"None";
NSString * const MTServiceContentTypeUserTimeline   = @"UserTimeline";
NSString * const MTServiceContentTypeUserWall       = @"UserWall";    
NSString * const MTServiceContentTypeUserPosts      = @"UserPosts";   
NSString * const MTServiceContentTypeUserMessages   = @"UserMessages";
NSString * const MTServiceContentTypeAny            = @"Any";         

NSString * const MTTwitterAppId         = @"wk79XRDGhXbiaN3o3XI2Cw";
NSString * const MTTwitterAppSecret     = @"jPJxaTAVUJdV768fUSUmCX6JHoVpTQ8WPPlwTqRWnz0";
NSString * const MTFacebookAppId        = @"351817994870666";
NSString * const MTFacebookAppSecret    = @"ecc46b32cb22e0d0db046c7d4b215fe9";
NSString * const MTGooglePlusAppId      = @"1045145999063.apps.googleusercontent.com";
NSString * const MTGooglePlusAppSecret  = @"OjrMiXR2pjojH4DPK_mwbsdB";
NSString * const MTTumblrAppId          = @"qRSmAxBAldFIt3n2ps8gfFz8P28qqzclahs0W5hyNFhz0qd65o";
NSString * const MTTumblrAppSecret      = @"IIZCqCQNqf3yASAQYMhgHBbJpIcV3WNb0y3JsGbx6cRu9IVDCU";
NSString * const MTFoursquareAppId      = @"WXCR2SKBXGFBTA2TXVHYQKIZCIKARV2Z5GB0052EHTTPKKFK";
NSString * const MTFoursquareAppSecret  = @"2IBJQP55I53X4OEJSD1TIDXAS2LNBU5RFXKVKF4HU3C3VOMU";
NSString * const MTFlickrAppId          = @"dj0yJmk9c0d3YVV4bUxRd2ZyJmQ9WVdrOU0zSnFORkZwTjJVbWNHbzlORGM0TURVek5qWXkmcz1jb25zdW1lcnNlY3JldCZ4PTYz";
NSString * const MTFlickrAppSecret      = @"48fc0958b5f0d78c1452f4cd4e8026e8399657ec";
NSString * const MTLinkedInAppId        = @"x7wc03d30wex";
NSString * const MTLinkedInAppSecret    = @"qpDILV6Un00wjfTe";

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

NSString * const MTTumblrDidStartLoading                = @"TumblrDidStartLoading";
NSString * const MTTumblrAuthenticationSucceeded        = @"TumblrAuthenticationSucceeded";
NSString * const MTTumblrNotAuthenticated               = @"TumblrNotAuthenticated";
NSString * const MTTumblrServiceNotConnected            = @"TumblrServiceNotConnected";
NSString * const MTTumblrAuthenticationFailed           = @"TumblrAuthenticationFailed";
NSString * const MTTumblrConnectionInterrupted          = @"TumblrConnectionInterrupted";
NSString * const MTTumblrConnectionReEstablished        = @"TumblrConnectionReEstablished";
NSString * const MTTumblrAccessNotGranted               = @"TumblrAccessNotGranted";
NSString * const MTTumblrNewsItemsReceived              = @"TumblrNewsItemsReceived";
NSString * const MTTumblrNewsItemsRequestFailed         = @"TumblrNewsItemsRequestFailed";
NSString * const MTTumblrLogoutCompleted                = @"TumblrLogoutCompleted";

NSString * const MTFlickrDidStartLoading                = @"FlickrDidStartLoading";
NSString * const MTFlickrAuthenticationSucceeded        = @"FlickrAuthenticationSucceeded";
NSString * const MTFlickrNotAuthenticated               = @"FlickrNotAuthenticated";
NSString * const MTFlickrServiceNotConnected            = @"FlickrServiceNotConnected";
NSString * const MTFlickrAuthenticationFailed           = @"FlickrAuthenticationFailed";
NSString * const MTFlickrConnectionInterrupted          = @"FlickrConnectionInterrupted";
NSString * const MTFlickrConnectionReEstablished        = @"FlickrConnectionReEstablished";
NSString * const MTFlickrAccessNotGranted               = @"FlickrAccessNotGranted";
NSString * const MTFlickrNewsItemsReceived              = @"FlickrNewsItemsReceived";
NSString * const MTFlickrNewsItemsRequestFailed         = @"FlickrNewsItemsRequestFailed";
NSString * const MTFlickrLogoutCompleted                = @"FlickrLogoutCompleted";

NSString * const MTFoursquareDidStartLoading            = @"FoursquareDidStartLoading";
NSString * const MTFoursquareAuthenticationSucceeded    = @"FoursquareAuthenticationSucceeded";
NSString * const MTFoursquareNotAuthenticated           = @"FoursquareNotAuthenticated";
NSString * const MTFoursquareServiceNotConnected        = @"FoursquareServiceNotConnected";
NSString * const MTFoursquareAuthenticationFailed       = @"FoursquareAuthenticationFailed";
NSString * const MTFoursquareConnectionInterrupted      = @"FoursquareConnectionInterrupted";
NSString * const MTFoursquareConnectionReEstablished    = @"FoursquareConnectionReEstablished";
NSString * const MTFoursquareAccessNotGranted           = @"FoursquareAccessNotGranted";
NSString * const MTFoursquareNewsItemsReceived          = @"FoursquareNewsItemsReceived";
NSString * const MTFoursquareNewsItemsRequestFailed     = @"FoursquareNewsItemsRequestFailed";
NSString * const MTFoursquareLogoutCompleted            = @"FoursquareLogoutCompleted";
NSString * const MTFoursquareAccessNotGrantedErrorMsg   = @"access_denied";
NSString * const MTFoursquareAuthenticationErrorKey     = @"error";
NSString * const MTFoursquareOAuth2DialogNeedsDisplay   = @"FoursquareOAuth2DialogNeedsDisplay";
NSString * const MTFoursquareOAuth2DialogNeedsDismissal = @"FoursquareOAuth2DialogNeedsDismissal";

NSString * const MTLinkedInDidStartLoading              = @"LinkedInDidStartLoading";
NSString * const MTLinkedInAuthenticationSucceeded      = @"LinkedInAuthenticationSucceeded";
NSString * const MTLinkedInNotAuthenticated             = @"LinkedInNotAuthenticated";
NSString * const MTLinkedInServiceNotConnected          = @"LinkedInServiceNotConnected";
NSString * const MTLinkedInAuthenticationFailed         = @"LinkedInAuthenticationFailed";
NSString * const MTLinkedInConnectionInterrupted        = @"LinkedInConnectionInterrupted";
NSString * const MTLinkedInConnectionReEstablished      = @"LinkedInConnectionReEstablished";
NSString * const MTLinkedInAccessNotGranted             = @"LinkedInAccessNotGranted";
NSString * const MTLinkedInNewsItemsReceived            = @"LinkedInNewsItemsReceived";
NSString * const MTLinkedInNewsItemsRequestFailed       = @"LinkedInNewsItemsRequestFailed";
NSString * const MTLinkedInLogoutCompleted              = @"LinkedInLogoutCompleted";

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