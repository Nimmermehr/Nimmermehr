//
//  UIImage+Utils.m
//  iStream
//
//  Created by Thomas Kober on 4/12/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

- (id)initWithContentsOfURL:(NSURL *)theURL
{
    NSData *imgData = [NSData dataWithContentsOfURL:theURL];
    
    return [self initWithData:imgData];
}

+ (id)imageWithContentsOfURL:(NSURL *)theURL
{
    NSData *imgData = [NSData dataWithContentsOfURL:theURL];
    
    return [UIImage imageWithData:imgData];
}

@end
