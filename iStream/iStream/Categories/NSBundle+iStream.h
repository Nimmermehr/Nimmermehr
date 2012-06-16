//
//  NSBundle+iStream.h
//  iStream
//
//  Created by Thomas Kober on 5/12/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (iStream)

+ (UIImage *)getServiceIconForService:(NSString *)serviceType;

+ (UIImage *)getImage:(NSString *)imageName withExtension:(NSString *)extension;

@end
