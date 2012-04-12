//
//  UIImage+Utils.h
//  iStream
//
//  Created by Thomas Kober on 4/12/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

- (id)initWithContentsOfURL:(NSURL *)theURL;
+ (id)imageWithContentsOfURL:(NSURL *)theURL;

@end
