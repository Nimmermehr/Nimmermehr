//
//  MTUser.h
//  iStream
//
//  Created by Thomas Kober on 4/14/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

// Encapsulate all relevant data for the currently logged in (iStream-) User
// eg. Facebook Id, Facebook Profile Pic, Twitter Profile Pic, etc
// also its good to cache the Users graphical assets as FB Posts don't contain that

@interface MTUser : NSObject {
    
    // Facebook Data
    UIImage     *_facebookProfileImage;
    NSUInteger  _facebookUserId;
    
    // Twitter Data
    UIImage     *_twitterProfileImage;
    
    // G+ Data
    UIImage     *_googlePlusProfileImage;
}

@property (strong, nonatomic)   UIImage     *facebookProfileImage;
@property (nonatomic)           NSUInteger  facebookUserId;

@property (strong, nonatomic)   UIImage     *twitterProfileImage;

@property (strong, nonatomic)   UIImage     *googlePlusProfileImage;

@end
