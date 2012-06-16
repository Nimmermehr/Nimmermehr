//
//  MTConstants.h
//  iStream
//
//  Created by Thomas Kober on 3/31/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const MTServiceContentTypeNone;
extern NSString * const MTServiceContentTypeUserTimeline;   // FB, G+, Twitter main timeline
extern NSString * const MTServiceContentTypeUserWall;       // FB, G+ Wall, Twitter @msgs
extern NSString * const MTServiceContentTypeUserPosts;      // FB, G+, Twitter user posts
extern NSString * const MTServiceContentTypeUserMessages;   // FB, G+, Twitter Direct Messages
extern NSString * const MTServiceContentTypeAny;            // Just anything we can find, used for requests only, not for newsitem specification

extern NSString * const MTServiceTypeTwitter;
extern NSString * const MTServiceTypeFacebook;
extern NSString * const MTServiceTypeTumblr;
extern NSString * const MTServiceTypeGooglePlus;
extern NSString * const MTServiceTypeFoursquare;
extern NSString * const MTServiceTypeFlickr;
extern NSString * const MTServiceTypeLinkedIn;
extern NSString * const MTServiceTypeBitly;

extern NSString * const MTTwitterAppId;
extern NSString * const MTTwitterAppSecret;
extern NSString * const MTFacebookAppId;
extern NSString * const MTFacebookAppSecret;
extern NSString * const MTGooglePlusAppId;
extern NSString * const MTGooglePlusAppSecret;
extern NSString * const MTTumblrAppId;
extern NSString * const MTTumblrAppSecret;
extern NSString * const MTFoursquareAppId;
extern NSString * const MTFoursquareAppSecret;
extern NSString * const MTFlickrAppId;
extern NSString * const MTFlickrAppSecret;
extern NSString * const MTLinkedInAppId;
extern NSString * const MTLinkedInAppSecret;

extern NSString * const MTTwitterDidStartLoading;
extern NSString * const MTTwitterAuthenticationSucceeded;
extern NSString * const MTTwitterNotAuthenticated;
extern NSString * const MTTwitterServiceNotConnected;
extern NSString * const MTTwitterAuthenticationFailed;
extern NSString * const MTTwitterConnectionInterrupted;
extern NSString * const MTTwitterConnectionReEstablished;
extern NSString * const MTTwitterAccessNotGranted;
extern NSString * const MTTwitterNewsItemsReceived;
extern NSString * const MTTwitterNewsItemsRequestFailed;
extern NSString * const MTTwitterLogoutCompleted;

extern NSString * const MTFacebookDidStartLoading;
extern NSString * const MTFacebookAuthenticationSucceeded;
extern NSString * const MTFacebookNotAuthenticated;   
extern NSString * const MTFacebookServiceNotConnected;
extern NSString * const MTFacebookAuthenticationFailed;
extern NSString * const MTFacebookConnectionInterrupted;
extern NSString * const MTFacebookConnectionReEstablished;
extern NSString * const MTFacebookAccessNotGranted;
extern NSString * const MTFacebookNewsItemsReceived;
extern NSString * const MTFacebookNewsItemsRequestFailed;
extern NSString * const MTFacebookLogoutCompleted;

extern NSString * const MTTumblrDidStartLoading;
extern NSString * const MTTumblrAuthenticationSucceeded;
extern NSString * const MTTumblrNotAuthenticated;
extern NSString * const MTTumblrServiceNotConnected;
extern NSString * const MTTumblrAuthenticationFailed;
extern NSString * const MTTumblrConnectionInterrupted;
extern NSString * const MTTumblrConnectionReEstablished;
extern NSString * const MTTumblrAccessNotGranted;
extern NSString * const MTTumblrNewsItemsReceived;
extern NSString * const MTTumblrNewsItemsRequestFailed;
extern NSString * const MTTumblrLogoutCompleted;

extern NSString * const MTFlickrDidStartLoading;
extern NSString * const MTFlickrAuthenticationSucceeded;
extern NSString * const MTFlickrNotAuthenticated;
extern NSString * const MTFlickrServiceNotConnected;
extern NSString * const MTFlickrAuthenticationFailed;
extern NSString * const MTFlickrConnectionInterrupted;
extern NSString * const MTFlickrConnectionReEstablished;
extern NSString * const MTFlickrAccessNotGranted;
extern NSString * const MTFlickrNewsItemsReceived;
extern NSString * const MTFlickrNewsItemsRequestFailed;
extern NSString * const MTFlickrLogoutCompleted;

extern NSString * const MTFoursquareDidStartLoading;
extern NSString * const MTFoursquareAuthenticationSucceeded;
extern NSString * const MTFoursquareNotAuthenticated;
extern NSString * const MTFoursquareServiceNotConnected;
extern NSString * const MTFoursquareAuthenticationFailed;
extern NSString * const MTFoursquareConnectionInterrupted;
extern NSString * const MTFoursquareConnectionReEstablished;
extern NSString * const MTFoursquareAccessNotGranted;
extern NSString * const MTFoursquareNewsItemsReceived;
extern NSString * const MTFoursquareNewsItemsRequestFailed;
extern NSString * const MTFoursquareLogoutCompleted;
extern NSString * const MTFoursquareAccessNotGrantedErrorMsg;
extern NSString * const MTFoursquareAuthenticationErrorKey;
extern NSString * const MTFoursquareOAuth2DialogNeedsDisplay;
extern NSString * const MTFoursquareOAuth2DialogNeedsDismissal;

extern NSString * const MTLinkedInDidStartLoading;
extern NSString * const MTLinkedInAuthenticationSucceeded;
extern NSString * const MTLinkedInNotAuthenticated;
extern NSString * const MTLinkedInServiceNotConnected;
extern NSString * const MTLinkedInAuthenticationFailed;
extern NSString * const MTLinkedInConnectionInterrupted;
extern NSString * const MTLinkedInConnectionReEstablished;
extern NSString * const MTLinkedInAccessNotGranted;
extern NSString * const MTLinkedInNewsItemsReceived;
extern NSString * const MTLinkedInNewsItemsRequestFailed;
extern NSString * const MTLinkedInLogoutCompleted;

extern NSString * const MTGooglePlusDidStartLoading;
extern NSString * const MTGooglePlusAuthenticationSucceeded;
extern NSString * const MTGooglePlusNotAuthenticated;
extern NSString * const MTGooglePlusServiceNotConnected;
extern NSString * const MTGooglePlusAuthenticationFailed;
extern NSString * const MTGooglePlusConnectionInterrupted;
extern NSString * const MTGooglePlusConnectionReEstablished;
extern NSString * const MTGooglePlusAccessNotGranted;
extern NSString * const MTGooglePlusNewsItemsReceived;
extern NSString * const MTGooglePlusNewsItemsRequestFailed;
extern NSString * const MTGooglePlusLogoutCompleted;
extern NSString * const MTGooglePlusOAuthScope;
extern NSInteger  const MTGooglePlusAccessNotGrantedErrorCode;
extern NSString * const MTGooglePlusOAuth2DialogNeedsDisplay;
extern NSString * const MTGooglePlusOAuth2DialogNeedsDismissal;

extern NSString * const MTAllServicesAuthenticationSucceeded;
extern NSString * const MTServiceNewsItemsReceived;
extern NSString * const MTServiceNewsItemsRequestFailed;
extern NSString * const MTServiceDidStartLoading;

extern NSString * const MTServiceAuthenticationErrorKey;
extern NSString * const MTServiceTypeKey;
extern NSString * const MTServiceContentKey;
extern NSString * const MTServiceContentRequestFailedErrorKey;
extern NSString * const MTServiceContentRequestFailedResponseKey;
extern NSString * const MTServiceOAuth2UserDialog;