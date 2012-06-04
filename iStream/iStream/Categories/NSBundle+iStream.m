//
//  NSBundle+iStream.m
//  iStream
//
//  Created by Thomas Kober on 5/12/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "NSBundle+iStream.h"
#import "UIImage+Utils.h"

@implementation NSBundle (iStream)

+ (UIImage *)getServiceIconForService:(NSString *)serviceType
{
    UIImage *serviceIcon = nil;
    
    if ([serviceType isEqualToString:MTServiceTypeTwitter]) {
        serviceIcon = [NSBundle getImage:@"twitterImg_32x32" withExtension:@"png"];
    }
    
    return serviceIcon;
}

+ (UIImage *)getImage:(NSString *)imageName withExtension:(NSString *)extension
{
    NSURL *resourceURL = [[self mainBundle] URLForResource:imageName withExtension:extension];
    
    return [UIImage imageWithContentsOfURL:resourceURL];
}

@end
