//
//  MTFoursquareConnector.m
//  iStream
//
//  Created by Thomas Kober on 4/25/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTFoursquareConnector.h"
#import "MTServiceConnectorDelegate.h"
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "MTNewsItem.h"
#import "NSURL+Utils.h"

#define FoursquareKeychainItemName  @"Foursquare"
#define FoursquareUserCheckInsURL   [NSURL URLWithString:@"https://api.foursquare.com/v2/users/self/checkins"]
#define FoursquareUserDetailsURL    [NSURL URLWithString:@"https://api.foursquare.com/v2/users/self"]
#define FoursquareAuthURL           [NSURL URLWithString:@"https://foursquare.com/oauth2/authenticate?response_type=token"]
#define FoursquareAPICheckDate      @"20120508"

@interface MTFoursquareConnector (Private)
- (void)sendFoursquareRequestWithURL:(NSURL *)theURL;
- (NSArray *)parseContent:(NSArray *)theTimeline;
@end

@implementation MTFoursquareConnector

@synthesize authenticated   = _authenticated;
@synthesize delegate        = _delegate;

- (id)init
{
    if ((self = [super init])) {
        _authenticated = NO;
        
    }
    
    return self;
}

- (void)authenticate
{
    // https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@
    NSString *redirectURI = @"http://www.tttthomasssss.com/";
    
    _authToken = [GTMOAuth2Authentication authenticationWithServiceProvider:MTServiceTypeFoursquare
                                                                   tokenURL:FoursquareAuthURL 
                                                                redirectURI:redirectURI 
                                                                   clientID:MTFoursquareAppId 
                                                               clientSecret:MTFoursquareAppSecret
                  ];
    
    _viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:_authToken
                                                                  authorizationURL:FoursquareAuthURL
                                                                  keychainItemName:FoursquareKeychainItemName
                                                                          delegate:self
                                                                  finishedSelector:@selector(viewController:finishedWithAuth:error:)
                       ];
    
    [_delegate displayOAuth2UserDialog:[self serviceType] userDialog:_viewController];
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error
{
    [_delegate dismissOAuth2UserDialog:[self serviceType]];
   
    if (!error) {
        
        _authToken = auth;
        
        _authenticated = YES;
        
        [_delegate serviceAuthenticatedSuccessfully:[self serviceType]];
    } else {
        
        _authenticated = NO;
        
        if ([[[error userInfo] objectForKey:MTFoursquareAuthenticationErrorKey] isEqualToString:MTFoursquareAccessNotGrantedErrorMsg]) {
            [_delegate accessNotGranted:[self serviceType]];
        } else {
            [_delegate serviceAuthenticationFailed:[self serviceType] errDict:[error userInfo]];
        }
    }
}

- (NSString *)serviceType
{
    return MTServiceTypeFoursquare;
}

- (void)requestCheckIns
{
    [self sendFoursquareRequestWithURL:FoursquareUserCheckInsURL];
}

- (void)logout
{
    
}

@end

@implementation MTFoursquareConnector (Private)

- (void)sendFoursquareRequestWithURL:(NSURL *)theURL
{
    
    //NSURL *reqURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?v=%@&oauth_token=%@", [FoursquareUserCheckInsURL absoluteString], FoursquareAPICheckDate, [_authToken accessToken]]];
    
    NSURL *reqURL = [FoursquareUserCheckInsURL URLByAppendingFormat:@"?v=%@&oauth_token=%@", FoursquareAPICheckDate, [_authToken accessToken]];
    
    NSMutableURLRequest *theReq = [NSMutableURLRequest requestWithURL:reqURL];
    
    [NSURLConnection sendAsynchronousRequest:theReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *theData, NSError *terror){
        
        if (!terror) {
            
            NSError *jsonTerror = nil;
            
            NSDictionary *foursqureContent = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonTerror];
            
            NSLog(@"FOURSQUARE SHIT: %@", foursqureContent);
            
            NSDictionary *responseDict = [[foursqureContent objectForKey:@"response"] objectForKey:@"checkins"]; //<-- TODO: THIS IS DANGEROUS!!!!
            
            NSDictionary *newPosts = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [self parseContent:[responseDict objectForKey:@"items"]], MTServiceContentKey,
                                      [self serviceType],                                       MTServiceTypeKey,
                                      nil
                                      ];
            
            [_delegate contentReceived:newPosts];
            
        } else {
            NSDictionary *errDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [self serviceType], MTServiceTypeKey,
                                        terror,             MTServiceContentRequestFailedErrorKey,
                                        nil
                                     ];
            
            [_delegate contentRequestFailed:errDict];
        }
        
    }];
}

- (NSArray *)parseContent:(NSArray *)theTimeline
{
    NSMutableArray *newPosts = [NSMutableArray array];
    
    MTNewsItem *thePost = nil;
    
    NSDate *timestamp = nil;
    
    NSTimeInterval theInterval = 0;
    
    NSString *content = nil;
    
    for (NSDictionary *theDict in theTimeline) {
        
        theInterval = [[theDict objectForKey:@"createdAt"] doubleValue];
        
        timestamp = [NSDate dateWithTimeIntervalSince1970:theInterval];
        
        content = [NSString stringWithFormat:@"%@ @ %@", [theDict objectForKey:@"type"], [[theDict objectForKey:@"venue"] objectForKey:@"name"]];
        
        thePost = [[MTNewsItem alloc] initWithAuthor:@"" /*Get the cached user stuffs*/ 
                                             content:content
                                  serviceContentType:nil // TODO: SERVICECONTENTTYPE!!!! 
                                      authorRealName:@"" 
                                           timestamp:timestamp
                                  authorProfileImage:nil 
                                adherentConversation:nil 
                                  conversationLength:0 
                                          shareCount:0 
                                        taggedPeople:nil
                                      repliedToMsgId:nil//TODO:
                   ];
        
        [newPosts addObject:thePost];
    }
    
    return (NSArray *)newPosts;
}

@end
